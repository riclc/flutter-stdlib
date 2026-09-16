
// usa biblioteca: sprintf
import 'package:sprintf/sprintf.dart';

void printf(String fmt, [var args = null]) {
  print( sprintf(fmt, args ?? []) );
}
