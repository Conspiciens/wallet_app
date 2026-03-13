import 'package:flutter/material.dart';
import 'package:wallet_app/core/keys_manager.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/pages/new_wallet.dart';
import 'package:wallet_app/pages/wallet.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key}); 
  
  @override
  State<WalletsPage> createState() => _WalletsPageState(); 
}

class _WalletsPageState extends State<WalletsPage> {
  KeysManager? keys;
  TextEditingController passController = TextEditingController(); 

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
    KeysManager.getInstance().then(
      (value) => keys = value);
    
    if (keys != null) { 
      keys?.loadKeys();
    }
  }

  Future<List<String>> getKeys() async {
    return keys != null ? keys?.getKeys() ?? Future.value([]) : Future.value([]);
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewWallet()
                        )
                      ); 
                    }, 
                    icon: Icon(Icons.add) 
                  ),
                ]
              ), 
              
              // if (keys == null)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child:
                      FutureBuilder<List<String>>(
                        future: getKeys(), 
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return ListTile(); 
                          } 

                          final items = snapshot.data;
                          print(items);
                          return SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsetsGeometry.only(top: 20.0), 
                                  child: WalletWidget(
                                  item: items[index], 
                                  onTap: () async {
                                    _dialogBuilder(context, passController, items[index]); 
                                  }),
                                ); 
                              }
                            ), 
                          ); 
                        }
                      )
                  ), 
                ]
              ), 
            ]
          )
        ),
    );
  }
}

class WalletWidget extends StatelessWidget {
  final String item; 
  final VoidCallback onTap; 

  const WalletWidget({super.key, required this.item, required this.onTap}); 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 100,
      title: Text(item),
      titleAlignment: ListTileTitleAlignment.center,
      tileColor: Colors.lightBlue.shade200,
      enabled: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1), 
        borderRadius: BorderRadius.circular(20), 
      ),
      onTap: onTap,
    );    
  }
}

class WalletBuilder extends StatefulWidget {
  const WalletBuilder({super.key});

  @override
  State<StatefulWidget> createState() => _WalletBuilderState();
}

class _WalletBuilderState extends State<WalletBuilder> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Future<void> _dialogBuilder(
  BuildContext context, 
  TextEditingController passController, 
  final item, 
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
              String? pass = await SecureStorage().readStorage(item); 
              if (pass == null || pass != passController.text) { return; }
              if (!context.mounted) { return; } 
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WalletPage(itemKey: item)));
            },
          )
        ]
      ); 
    });  
}