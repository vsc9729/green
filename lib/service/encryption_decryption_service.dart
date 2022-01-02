import 'package:encrypt/encrypt.dart' as encrypt;
class EncryptionDecryptionService{
  static final iv = encrypt.IV.fromLength(16);

  generateKey(){
    return encrypt.Key.fromSecureRandom(32).base64;
  }
  retrieveKey(key){
    return encrypt.Key.fromBase64(key);
  }
  encryptAES(text, key){
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text,iv:iv);
    return encrypted.base64;
  }
  decryptAES(text, key){
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(text), iv:iv);
  }
}