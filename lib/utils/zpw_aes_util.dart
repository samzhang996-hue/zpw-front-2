import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';



// ignore_for_file: constant_identifier_names

class ZpwAESUtil {

  static String _zpwKey = "";
  static String _zpwIv = "";

  static dynamic zpwTkAesEncrypt(encrypted,String key){
    _zpwKey = key;
    _zpwIv = key;
    return zpwAesEncrypt(encrypted);
  }
  static dynamic zpwTkAesDecrypt(String encrypted,String key){
    _zpwKey = key;
    _zpwIv = key;
    return zpwAesDecrypt(encrypted);
  }
  //AES解密
  static dynamic zpwAesDecrypt(String encrypted) {
    try {
      final key = Key.fromUtf8(_zpwKey);
      final iv = IV.fromUtf8(_zpwIv);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);
      return decrypted;
    } catch (err) {
      print("aes decode error:$err");
      return encrypted;
    }
  }
  //AES加密
  static Uint8List zpwAesEncrypt(plainText) {
    try {
      final key = Key.fromUtf8(_zpwKey);
      final iv = IV.fromUtf8(_zpwIv);
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
  static String zpwEncodeBase64(String data) {
    return base64Encode(utf8.encode(data));
  }

  //Base64解码
  static String zpwDecodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  // md5 加密 32位小写
  static String zpwEncodeMd5(String plainText) {
    return ZpwAESUtil.zpwEncodeMd5(plainText);
  }

}

class ZpwHexUtil {

  static Uint8List zpwCreateUint8ListFromHex(String hex){
    if(hex == null) throw new ArgumentError("the hex is null");
    var result = Uint8List(hex.length ~/ 2);
    for(var i = 0; i < hex.length; i += 2){
      var num = hex.substring(i,i + 2);
      var byte = int.parse(num,radix: 16);
      result[i ~/ 2] = byte;
    }
    return result;
  }

  static String zpwFrombytesAsHexString(Uint8List bytes){
    if(bytes == null) throw new ArgumentError("the list is null");
    var result = new StringBuffer();
    for(var i = 0;i < bytes.lengthInBytes;i ++){
      var part = bytes[i];
      result.write("${part < 16 ? "0" : ""}${part.toRadixString(16)}");
    }
    return result.toString();
  }
}