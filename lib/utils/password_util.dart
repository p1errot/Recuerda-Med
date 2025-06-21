import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordUtil {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}
