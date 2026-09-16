
// usa biblioteca: hashlib
import 'package:hashlib/hashlib.dart';

//
//

String hash_md5(String s) {
  return md5.string(s).hex();
}

String hash_sha256(String s) {
  return sha256.string(s).hex();
}

String hash_sha512(String s) {
  return sha512.string(s).hex();
}
