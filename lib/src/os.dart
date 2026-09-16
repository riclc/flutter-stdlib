import 'dart:io';

enum OsGetType { desktop, mobile }

//
//
//

OsGetType os_get_type() {
  if (Platform.isAndroid || Platform.isIOS) {
    return .mobile;
  } else {
    return .desktop;
  }
}

int os_get_argc() {
  return Platform.executableArguments.length;
}

List<String> os_get_argv() {
  return Platform.executableArguments;
}

String? os_get_env(String s) {
  return Platform.environment[s];
}

int os_get_pid() {
  return pid;
}

//
//

void os_mkdir(String path, {bool full_path = false}) {
  Directory(path).createSync(recursive: full_path);
}

void os_rmdir(String path) {
  Directory(path).deleteSync();
}

void os_rename(String path, String newPath) {
  final entity = FileSystemEntity.typeSync(path);

  switch (entity) {
    case .file:
      File(path).rename(newPath);
      break;

    case .directory:
      Directory(path).rename(newPath);
      break;

    case .link:
      Link(path).rename(newPath);
      break;

    default:
      break;
  }
}

void os_rm(String path, {bool recursive = false}) {
  final entity = FileSystemEntity.typeSync(path);

  switch (entity) {
    case .file:
      File(path).deleteSync();
      break;

    case .directory:
      Directory(path).deleteSync(recursive: recursive);
      break;

    case .link:
      Link(path).deleteSync();
      break;

    default:
      break;
  }
}
