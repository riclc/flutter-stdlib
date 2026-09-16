import 'dart:io';

// usa bibliotecas: path, path_provider
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';

//
//
//

String os_path_join(
  String arg1, [
  String? arg2,
  String? arg3,
  String? arg4,
  String? arg5,
  String? arg6,
  String? arg7,
  String? arg8,
]) {
  return path_lib.normalize(
    path_lib.join(
      arg1,
      arg2,
      arg3,
      arg4,
      arg5,
      arg6,
      arg7,
      arg8,
    ),
  );
}

//
//
//

bool os_path_is_dir(String path) {
  return FileSystemEntity.isDirectorySync(path);
}

bool os_path_is_file(String path) {
  return FileSystemEntity.isFileSync(path);
}

bool os_path_is_link(String path) {
  return FileSystemEntity.isLinkSync(path);
}

String os_path_normalize(String path) {
  return path_lib.normalize(path);
}

//////

/// ex.: /a/b/c.dat  -> /a/b
///
String os_path_extract_dir(String path) {
  return path_lib.dirname(path);
}

/// ex.: /a/b/c.dat -> c.dat
///
String os_path_extract_base(String path) {
  return path_lib.basename(path);
}

/// ex.: /a/b/c.dat -> c
///
String os_path_extract_name(String path) {
  var base = path_lib.basename(path);
  return path_lib.withoutExtension(base);
}

/// ex.: /a/b/c.dat  -> .dat
///
String os_path_extract_ext(String path) {
  return path_lib.extension(path);
}

//
//

String os_path_to_url(String path) {
  return path_lib.fromUri(path);
}

String os_path_from_url(String path) {
  return path_lib.fromUri(path);
}

bool os_path_exists(String path) {
  // File(arq).existsSync();  // só pra arquivos
  return FileSystemEntity.typeSync(path) !=
      FileSystemEntityType.notFound;
}

///////////////////////////////
//
//
//

// Linux: /home/<conta>/a/b/programa (diretório raiz do app)
// Android: /
//
String os_path_get_cwd() {
  return Directory.current.path;
}

// Linux: /home/<conta>/a/b/programa/build/linux/x64/debug/bundle/arq
// Android: /system/bin/app_process64
//
String os_path_get_exename() {
  return Platform.resolvedExecutable;
}

// Linux: /home/<conta>/.local/share/com.example.programa1
// Android: /data/user/0/com.example.programa1/files
//
Future<String> os_path_get_app_dir() async {
  return (await getApplicationSupportDirectory()).path;
}

// Linux: /home/<conta>/Documents
// Android: /data/user/0/com.example.programa1/app_flutter
//
Future<String> os_path_get_docs_dir() async {
  return (await getApplicationDocumentsDirectory()).path;
}

// Linux: /home/<conta>/Downloads
// Android: /storage/emulated/0/Android/data/com.example.programa1/files/Download
//
Future<String> os_path_get_downloads_dir() async {
  var d = await getDownloadsDirectory();
  if (d != null) return d.path;
  return "";
}

//  Linux:   /tmp
//  Android: /data/user/0/com.example.programa1/cache
//
Future<String> os_path_get_temp_dir() async {
  return (await getTemporaryDirectory()).path;
}

//
//

List<FileSystemEntity> os_path_listdir(
  String path, {
  bool recursive = false,
  bool follow_links = true,
}) {
  return Directory(path).listSync(
    followLinks: follow_links,
    recursive: recursive,
  );
}

/// exemplo para usar:
///   var arqs = os_path_listdir(...);
///   await for (var arq in arqs) { ... }
///
/// ou ainda:
///   var arqs = await os_path_listdir(...).toList();
///
Stream<FileSystemEntity> os_path_listdir_stream(
  String path, {
  bool recursive = false,
  bool follow_links = true,
}) {
  return Directory(
    path,
  ).list(followLinks: follow_links, recursive: recursive);
}

Future<int> os_path_get_size(String path) async {
  if (FileSystemEntity.isFileSync(path)) {
    return File(path).length();
  }

  if (FileSystemEntity.isDirectorySync(path)) {
    var f = Directory(path);
    var total = 0;

    await for (var item in f.list(recursive: true)) {
      if (item is File) {
        total += await item.length();
      }
    }

    return total;
  }

  return 0;
}

////
//

enum OsPathListSortBy {
  path,
  size,
  last_modification,
  type,
}

void os_path_list_sort(
  List<FileSystemEntity> paths, {
  OsPathListSortBy by = .path,
  bool reverse = false,
  bool directories_first = true,
}) {
  final nomes = <FileSystemEntity, String>{};
  final sizes = <FileSystemEntity, int>{};
  final dates = <FileSystemEntity, DateTime>{};
  final types = <FileSystemEntity, String>{};
  final is_dir = <FileSystemEntity, bool>{};

  for (var path in paths) {
    nomes[path] = path.path.toLowerCase();

    is_dir[path] = path is Directory;

    if (by == .size || by == .last_modification) {
      final stat = path.statSync();

      sizes[path] = stat.size;
      dates[path] = stat.modified;
    }

    if (by == .type) {
      types[path] = path_lib
          .extension(path.path)
          .toLowerCase();
    }
  }

  paths.sort((a, b) {
    if (directories_first) {
      final a_is_dir = is_dir[a]!;
      final b_is_dir = is_dir[b]!;

      if (a_is_dir != b_is_dir) {
        return a_is_dir ? -1 : 1;
      }
    }

    int result;

    switch (by) {
      case .path:
        result = nomes[a]!.compareTo(nomes[b]!);
        break;

      case .size:
        // os maiores vêm primeiro
        result = -sizes[a]!.compareTo(sizes[b]!);
        break;

      case .last_modification:
        // os mais recentes vêm primeiro
        result = -dates[a]!.compareTo(dates[b]!);
        break;

      case .type:
        result = types[a]!.compareTo(types[b]!);
        break;
    }

    // em 2o lugar, usa o path dentro da categoria do sort
    if (result == 0 && by != .path) {
      result = nomes[a]!.compareTo(nomes[b]!);
    }

    return reverse ? -result : result;
  });
}

void os_path_list_filter(
  List<FileSystemEntity> paths, {
  bool show_dirs = true,
  bool show_hidden = true,
  String? search_name,
  Set<String>? show_only_files_with_ext,
}) {
  paths.removeWhere((path) {
    final filename = path_lib.basename(path.path);
    final is_dir = path is Directory;

    if (!show_dirs && is_dir) {
      return true;
    }

    if (!show_hidden && filename.startsWith('.')) {
      return true;
    }

    if (search_name != null &&
        !filename.toLowerCase().contains(
          search_name.toLowerCase(),
        )) {
      return true;
    }

    if (show_only_files_with_ext != null && !is_dir) {
      final ext = path_lib
          .extension(path.path)
          .toLowerCase();

      if (!show_only_files_with_ext.contains(ext)) {
        return true;
      }
    }

    return false;
  });
}
