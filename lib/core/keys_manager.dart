import 'package:shared_preferences/shared_preferences.dart';

class KeysManager {
  String _key = "mobile_keys_save"; 
  final SharedPreferences drive; 
  static final Future<KeysManager> _instance = _init(); 

  static Future<KeysManager> getInstance() async {
    return await _instance; 
  }

  static Future<KeysManager> _init() async {
    final drive = await SharedPreferences.getInstance();
    return KeysManager._internal(drive);
  }

  
  List<String> getKeys() {
    return drive.getStringList('mobile_keys_save') ?? [];
  }

  String addKey() {
    List<String> keys = drive.getStringList(_key) ?? []; 

    String keyName = "Key${keys.length.toString()}";  

    keys.add(keyName); 
    drive.setStringList('mobile_keys_save', keys);

    return keyName;
  }

  void clearKeys() {
    drive.setStringList('mobile_keys_save', []);
  }

  KeysManager._internal(this.drive); 
}