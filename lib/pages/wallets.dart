import 'package:flutter/material.dart';
import 'package:wallet_app/core/keys_manager.dart';
import 'package:wallet_app/pages/new_wallet.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/pages/wallet.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key}); 
  
  @override
  State<WalletsPage> createState() => _WalletsPageState(); 
}

class _WalletsPageState extends State<WalletsPage> {
  KeysManager? keys;

  @override 
  void initState() {
    super.initState(); 

    _initKeys();
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
        child: SingleChildScrollView(
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: CarouselView(
                    shape: const BeveledRectangleBorder(),
                    scrollDirection: Axis.vertical,
                    itemExtent: 100,
                    children: [
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
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return WalletWidget(item: items[index]); 
                            }
                          ); 
                        }

                      )
                    ]
                  ), 
                ), 
            ]
          )
        ),
      )
    );
  }
}

class WalletWidget extends StatelessWidget {
  final dynamic item; 

  const WalletWidget({super.key, required this.item}); 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        SecureStorage storage = SecureStorage(); 
        String? privateKey = await storage.readStorage(item);

        if (privateKey == null) {
          return; 
        }

        // Navigator.of(context).;
      },
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
