import 'package:shared_preferences/shared_preferences.dart';

class KeysManager {
  List<String> _keys = []; 
  final SharedPreferences drive; 
  static final Future<KeysManager> _instance = _init(); 

  static Future<KeysManager> getInstance() {
    return _instance; 
  }

  static Future<KeysManager> _init() async {
    final drive = await SharedPreferences.getInstance();
    return KeysManager._internal(drive);
  }
  
  Future<List<String>> getKeys() async {
    await loadKeys(); 
    return _keys;
    // return drive.getStringList('mobile_keys.save') ?? [];
  }

  Future<void> loadKeys() async {
    _keys = drive.getStringList('mobile_keys_save') ?? [];
  }

  Future<String> addKey() async {
    String keyName = "Key${_keys.length.toString()}";  

    _keys.add(keyName); 
    drive.setStringList('mobile_keys_save', _keys);

    return keyName;
  }

  Future<void> clearKeys() async {
    _keys.clear(); 
    drive.setStringList('mobile_keys_save', _keys);
  }

  KeysManager._internal(this.drive); 
}