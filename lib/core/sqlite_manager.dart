import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher/sql.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

class SqliteManager {
    static SqliteManager? _instance; 
    Database? db; 

    static Future<SqliteManager> _create(String pass) async {
      String path = dotenv.get("DB_PATH"); 

      var db = await openDatabase(
        path, 
        password: pass,  
        version: 1, 
        onCreate: (db, version) async {
          var batch = db.batch(); 

          batch.execute('''CREATE TABLE Wallets 
            (id INTEGER, PRIMARY KEY, name STRING, wallet_json STRING)'''); 
          await batch.commit(); 
        }
      );

      return SqliteManager._internal(db);

    }

    /* Private constructor */ 
    SqliteManager._internal(Database this.db); 
}
