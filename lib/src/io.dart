import 'dart:convert';
import 'dart:io';


// terminal
//

String input() {
  return stdin.readLineSync() ?? '';
}

void clear() {
  stdout.write('\x1B[2J\x1B[0;0H');
}

// arquivos
//

String load_str(String arq) {
  return File(arq).readAsStringSync();
}

void save_str(String arq, String s) {
  File(arq).writeAsStringSync(s);
}

//

dynamic load_json(String arq) {
  String s = load_str(arq);
  return jsonDecode(s);
}

void save_json(String arq, dynamic obj) {
  String s = jsonEncode(obj);
  save_str(arq, s);
}

//
//

List<String> read_lines(String arq) {
  return File(arq).readAsLinesSync();
}

void write_lines(String arq, List<String> ls) {
  File(arq).writeAsStringSync(ls.join('\n'));
}

// estilo python
//
class FileObj {
  final RandomAccessFile f;
  final String mode;
  final Encoding encoding;

  FileObj._(this.f, this.mode, this.encoding);

  String read([int? count]) {
    final length = f.lengthSync();
    final bytes = f.readSync(length);
    return encoding.decode(bytes);
  }

  void write(String data) {
    f.writeStringSync(data, encoding: encoding);
  }

  void close() {
    f.closeSync();
  }
}

FileObj open(
  String path, [
  String mode = 'r',
  Encoding encoding = utf8,
]) {
  final file = File(path);
  FileMode fileMode;

  switch (mode) {
    case 'r':
      fileMode = FileMode.read;
      break;
    case 'w':
      fileMode = FileMode.write; // sobrescreve
      break;
    case 'a':
      fileMode = FileMode.append; // adiciona ao final
      break;
    default:
      throw ArgumentError('*** Modo não suportado: $mode');
  }

  final f = file.openSync(mode: fileMode);
  return FileObj._(f, mode, encoding);
}
