import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

getGUID() {
  final uuid = Uuid();
  String guid = uuid.v4();
  return guid;
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
