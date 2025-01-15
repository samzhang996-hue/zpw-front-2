


// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';


class AESUtil {

  static String _KEY = "";
  static String _IV = "";

  static dynamic tkAesEncrypt(encrypted,String key){
    _KEY = key;
    _IV = key;
    return aesEncrypt(encrypted);
  }
  static dynamic tkAesDecrypt(String encrypted,String key){
    _KEY = key;
    _IV = key;
    return aesDecrypt(encrypted);
  }
  //AES解密
  static dynamic aesDecrypt(String encrypted) {
    try {
      final key = Key.fromUtf8(_KEY);
      final iv = IV.fromUtf8(_IV);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);
      return decrypted;
    } catch (err) {
      print("aes decode error:$err");
      return encrypted;
    }
  }
  //AES加密
  static Uint8List aesEncrypt(plainText) {
    try {
      final key = Key.fromUtf8(_KEY);
      final iv = IV.fromUtf8(_IV);
      /// 这里可以配置类型，
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.bytes;
    } catch (err) {
      print("aes encode error:$err");
      return plainText;
    }
  }
  //Base64编码
  static String encodeBase64(String data) {
    return base64Encode(utf8.encode(data));
  }

  //Base64解码
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  // md5 加密 32位小写
  static String encodeMd5(String plainText) {
    return AESUtil.encodeMd5(plainText);
  }

}

class HexUtil {

  static Uint8List createUint8ListFromHex(String hex){
    if(hex == null) throw new ArgumentError("the hex is null");
    var result = Uint8List(hex.length ~/ 2);
    for(var i = 0; i < hex.length; i += 2){
      var num = hex.substring(i,i + 2);
      var byte = int.parse(num,radix: 16);
      result[i ~/ 2] = byte;
    }
    return result;
  }

  static String frombytesAsHexString(Uint8List bytes){
    if(bytes == null) throw new ArgumentError("the list is null");
    var result = new StringBuffer();
    for(var i = 0;i < bytes.lengthInBytes;i ++){
      var part = bytes[i];
      result.write("${part < 16 ? "0" : ""}${part.toRadixString(16)}");
    }
    return result.toString();
  }
}