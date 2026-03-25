import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/core/sqlite_manager.dart';
import 'package:wallet_app/pages/new_wallet.dart';
import 'package:wallet_app/pages/wallet.dart';
import 'package:flutter/foundation.dart';

class WalletsPage extends StatefulWidget {
  final String email; 

  const WalletsPage({super.key, required this.email}); 
  
  @override
  State<WalletsPage> createState() => _WalletsPageState(); 
}

class _WalletsPageState extends State<WalletsPage> {
  SecureStorage storage = SecureStorage(); 
  SqliteManager? sqlite; 
  TextEditingController passController = TextEditingController(); 
  List<dynamic> items = []; 

  @override 
  void initState() {
    super.initState(); 

    _initKeys();
  }

  @override 
  void dispose() {
    passController.dispose(); 

    super.dispose(); 
  }

  Future<void> _initKeys() async {
    String? pass = await storage.readStorage(widget.email); 

    if (pass == null) return; 
    sqlite = await SqliteManager.create(pass); 

    var result = await sqlite?.getWallets(); 
    if (result == null) return; 

    setState(() {
      items = List.from(result);     
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: [ 
                  IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewWallet(email: widget.email)
                        )
                      ); 
                      await _initKeys(); 
                    }, 
                    icon: Icon(Icons.add) 
                  ),
                ]
              ), 
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child:
                      SizedBox(
                        height: 700,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsetsGeometry.only(top: 20.0), 
                                child: Dismissible(
                                  key: Key(items[index]['name']), 
                                  onDismissed: (direction) async {
                                    /* TODO: Add confirmation when dimissing */ 
                                    print(items[index]['id']);

                                    await sqlite?.removeWallet(items[index]['id']); 
                                    await SecureStorage().removeKey(items[index]['id']);
                                    
                                    setState(() {
                                      items.removeAt(index); 
                                    });
                                  },
                                    child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(20.0),
                                    ),
                                    color: Colors.lightBlue.shade200,
                                    child: WalletBuilder(
                                      item: items[index]['name'], 
                                      onTap: () async {
                                        if (!context.mounted) return; 
                                        _dialogBuilder(context, passController, items[index], _initKeys, widget.email); 
                                      }, 
                                    ),
                                )
                              )
                            ); 
                          }
                        ), 
                      )
                  ) 
                ]
              ), 
            ]
          )
        ),
    );
  }
}

class WalletBuilder extends StatefulWidget {
    final String item; 
    final VoidCallback onTap; 

    const WalletBuilder({super.key, required this.item, required this.onTap}); 
    @override
    State<StatefulWidget> createState() => _WalletBuilderState();
}

class _WalletBuilderState extends State<WalletBuilder> {

    @override
    Widget build(BuildContext context) {
      return ListTile(
        minTileHeight: 100,
        title: Text(widget.item),
        titleAlignment: ListTileTitleAlignment.center,
        tileColor: Colors.lightBlue.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20.0),
        ),
        enabled: true,
        leading: Icon(
          Icons.wallet,
          size: 40.0,
        ),
        onTap: widget.onTap,
      );    
    }
}

Future<void> _dialogBuilder(
  BuildContext context, 
  TextEditingController passController, 
  final wallet, 
  AsyncCallback updateState,
  final email
  ) {

  return showDialog<void>(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Enter your password for this Wallet!"), 
        actions: <Widget>[
          TextField(
            controller: passController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3.0)))
            ),
          ),     
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge
            ), 
            child: const Text("Submit"), 
            onPressed: () async {
              String? pass = await SecureStorage().readStorage(wallet['id']); 

              if (pass == null) { return; }
              // else if (!BCrypt.checkpw(passController.text, pass)) { return; } 
              else if (!context.mounted) { return; }
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WalletPage(wallet: wallet, 
                  pass: passController.text, email: email))
              );
            },
          )
        ]
      ); 
    });  
}