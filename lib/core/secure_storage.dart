import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/* Singleton to Manage the Secure Storage from IOS and Android */
class SecureStorage {
  static SecureStorage? _instance; 
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.passcode
    )
  ); 

  factory SecureStorage() {
    _instance ??= SecureStorage._internal(); 
    return _instance!; 
  }
  /* Private constructor */ 
  SecureStorage._internal(); 

  Future<String?> readStorage(String key) async {
    if (key == "") return null; 
    return await _storage.read(key: key); 
  }

  Future<void> passStorageOrStoreWalletpass(String key, String? pass, bool isWallet) async {
    if (key == "") return; 

    if (isWallet) {
      await _storage.write(key: key, value: pass, iOptions: IOSOptions(
        accessibility: KeychainAccessibility.passcode
      )); 
      return; 
    } 

    var UUID = Uuid(); 
    var uid = UUID.v4();

    await _storage.write(key: key, value: uid, iOptions: IOSOptions(
      accessibility: KeychainAccessibility.passcode
    ));
  }

  Future<void> removeKey(String key) async {
    if (key == "") return; 
    await _storage.delete(key: key); 
  }
}