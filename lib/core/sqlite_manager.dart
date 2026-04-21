import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher/sql.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallet_app/core/config.dart'; 
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class SqliteManager {
    static String dbName = Config.DBNAME;
    static SqliteManager? _instance; 
    Database? db; 

    static Future<SqliteManager> create(String pass) async {
      if (_instance != null) { return _instance!; }; 

      final dir = await getDatabasesPath(); 
      String dbPth = join(dir, dbName); 

      try {
        var db = await openDatabase(
          dbPth, 
          password: pass,  
          version: 1, 
          readOnly: false,
          onConfigure: (db) async {
            await db.execute('PRAGMA journal_mode = WAL'); 
          }, 
          onCreate: (db, version) async {
            var batch = db.batch(); 

            batch.execute('''CREATE TABLE IF NOT EXISTS Wallets 
              (id TEXT PRIMARY KEY, 
              name TEXT, 
              wallet_json TEXT)'''); 
            await batch.commit(); 
          }
        );

        _instance ??= SqliteManager._internal(db, _instance);
        return _instance!;
      } catch (e) {
        print("Error: $e"); 
        throw Exception(e); 
      }
    }

    Future<void> storeWallet(String id, String name, String wallet_js) async {
      await db?.insert('Wallets', {'id': id, 'name': name, 'wallet_json': wallet_js}); 
    }

    Future<void> removeWallet(String id) async {
      if (id == "") return; 
      await db?.rawQuery('DELETE FROM Wallets WHERE id = \'$id\''); 
    } 

    Future<List<Map<String, Object?>>?> getWallet(String id) async {
      List<Map<String, Object?>>? map = await db?.rawQuery('SELECT $id FROM Wallets'); 
      
      return map;  
    }

    Future<List<Map<String, Object?>>?> getWallets() async {
      return await db?.rawQuery("SELECT * FROM Wallets"); 
    }

    Future<void> close() async {
      if (db == null) return; 
      await db!.close(); 
    }

    /* Private constructor */ 
    SqliteManager._internal(Database this.db, _instance); 
}
