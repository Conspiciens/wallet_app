import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/* Singleton to Manage the Secure Storage from IOS and Android */
class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();  
  final FlutterSecureStorage _storage = FlutterSecureStorage(); 

  factory SecureStorage() {
    return _instance; 
  }

  /* Private constructor */ 
  SecureStorage._internal(); 

  Future<String?> readStorage(String key) async {
    if (key == "") return null; 
    return await _storage.read(key: key); 
  }

  Future<void> writeStorage(String key, String value) async {
    if (key == "") return; 
    return await _storage.write(key: key, value: value); 
  }

  Future<(String, String)> readFileAndPass(String key) async {
    String? pass = await _storage.read(key: key); 
    String? jsonString = await _storage.read(key: "$key\\_f"); 

    if (pass == null || jsonString == null) { throw Exception("Error retrieving form Secure Storage"); }

    return (pass, jsonString); 
  }

  Future<void> writeFileAndPassStorage(String key, String jsonString, String pass) async {
    if (jsonString.isEmpty) {
      throw Exception("Empty Json file"); 
    } else if (pass.isEmpty) {
      throw Exception("Password is empty");
    }

    await _storage.write(key: key, value: pass); 
    await _storage.write(key: "$key\\_f", value: jsonString);
  }
}