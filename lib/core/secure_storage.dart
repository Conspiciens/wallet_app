import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';

/* Singleton to Manage the Secure Storage from IOS and Android */
class SecureStorage {
  static SecureStorage? _instance; 
  final FlutterSecureStorage _storage = FlutterSecureStorage(); 

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
      await _storage.write(key: key, value: pass); 
      return; 
    } 

    var UUID = Uuid(); 
    var uid = UUID.v4();

    await _storage.write(key: key, value: uid);
  }

  Future<void> removeKey(String key) async {
    if (key == "") return; 
    await _storage.delete(key: key); 
  }

  Future<void> writeStorage(String key, String walletName, String value) async {
    if (key == "") return; 
    if (value == "") return; 

    final String passHash = BCrypt.hashpw(value, BCrypt.gensalt()); 
    final String key_t = "$key\\_t"; 

    await _storage.write(key: key_t, value: walletName); 
    await _storage.write(key: key, value: passHash); 
  }

  Future<String?> getWalletName(String key) async {
    if (key == "") return null;
    final String key_t = "$key\\_t"; 

    return await _storage.read(key: key_t); 
  }

  Future<(String, String)> readFileAndPass(String key) async {
    String? pass = await _storage.read(key: key); 
    String? jsonString = await _storage.read(key: "$key\\_f"); 

    if (pass == null || jsonString == null) { throw Exception("Error retrieving form Secure Storage"); }

    return (pass, jsonString); 
  }

  Future<void> writeFileAndPassStorage(String key, String walletName, String jsonString, String pass) async {
    if (jsonString.isEmpty) {
      throw Exception("Empty Json file"); 
    } else if (pass.isEmpty) {
      throw Exception("Password is empty");
    }

    final String passHash = BCrypt.hashpw(pass, BCrypt.gensalt()); 
    final String key_t = "$key\\_t"; 

    await _storage.write(key: key, value: passHash); 
    await _storage.write(key: key_t, value: walletName); 
    await _storage.write(key: "$key\\_f", value: jsonString);
  }
}