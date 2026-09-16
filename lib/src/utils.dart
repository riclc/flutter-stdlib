import 'dart:math';

var _random = Random();

//
//

String bin(int x, [int? pad_left_bits]) {
  final s = x.toRadixString(2);
  if (pad_left_bits != null) {
    return s.padLeft(pad_left_bits, '0');
  } else {
    return s;
  }
}

String hex(int x, [int? pad_left_digits]) {
  final s = x.toRadixString(16).toUpperCase();
  if (pad_left_digits != null) {
    return s.padLeft(pad_left_digits, '0');
  } else {
    return s;
  }
}

//
//

int ord(String ch) {
  return ch.codeUnitAt(0);
}

String chr(int codigo) {
  return String.fromCharCode(codigo);
}

//
//

List<String> extract_words(
  String s, {
  String separators = ' \n\t,',
  String separators_include = ';.+-*/=()[]{}',
  String connectors = '"\'',
  bool allow_empty = false,
}) {
  final List<String> result = [];
  String current = '';
  final List<String> connector_stack = [];
  int i = 0;

  while (i < s.length) {
    final String char = s[i];
    final bool is_inside = connector_stack.isNotEmpty;

    if (is_inside) {
      current += char;

      if (connectors.contains(char) &&
          connector_stack.last == char) {
        connector_stack.removeLast();

        if (connector_stack.isEmpty) {
          if (allow_empty || current.isNotEmpty) {
            result.add(current);
          }
          current = '';
        }
      }
      i++;
      continue;
    }

    if (connectors.contains(char)) {
      if (allow_empty || current.isNotEmpty) {
        result.add(current);
      }
      current = char;
      connector_stack.add(char);
      i++;
      continue;
    }

    if (separators_include.contains(char)) {
      if (allow_empty || current.isNotEmpty) {
        result.add(current);
      }
      result.add(char);
      current = '';
      i++;
      continue;
    }

    if (separators.contains(char)) {
      if (allow_empty || current.isNotEmpty) {
        result.add(current);
      }
      current = '';
      i++;
      continue;
    }

    current += char;
    i++;
  }

  if (connector_stack.isNotEmpty) {
    if (allow_empty || current.isNotEmpty) {
      result.add(current);
    }
  } else if (current.isNotEmpty &&
      (allow_empty || current.isNotEmpty)) {
    result.add(current);
  }

  return result;
}

//
//

int random_int(int min, int max) {
  return min + _random.nextInt(max - min + 1);
}

/// Escolhe um item aleatório da lista [seq].
/// Se [remove] for `true`, retira o item da lista original.
/// 
T? random_choice<T>(List<T>? seq, {bool remove = false}) {
  if (seq == null || seq.isEmpty) return null;

  int i = _random.nextInt(seq.length);

  if (remove) {
    return seq.removeAt(i);
  }

  return seq[i];
}

void random_shuffle<T>(List<T> array) {
  array.shuffle();
}

//
//
//

double lerp(double a, double b, double t) {
  return a + (b - a) * t;
}

double clamp(double x, [double min = 0, double max = 1]) {
  return x.clamp(min, max);
}

//
//

double deg_to_rad(double deg) {
  return (deg * pi) / 180;
}

double rad_to_deg(double rad) {
  return (rad * 180) / pi;
}

// octave
//
double sind(double deg) {
  return sin(deg_to_rad(deg));
}

double cosd(double deg) {
  return cos(deg_to_rad(deg));
}


//
//

String file_size_to_str(int bytes) {
  const opcoes = ['b', 'kb', 'mb', 'gb', 'tb'];

  var tamanho = bytes.toDouble();
  var i = 0;

  while (tamanho >= 1024 && i < opcoes.length - 1) {
    tamanho /= 1024;
    i++;
  }

  return tamanho.toStringAsFixed(2) + ' ' + opcoes[i];
}
