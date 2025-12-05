import 'package:flutter/material.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:web3dart/web3dart.dart'; 

class WalletPage extends StatefulWidget {
  final SecureStorage storage = SecureStorage(); 
  final String itemKey; 

  WalletPage({super.key, required this.itemKey});

  @override
  State<StatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Wallet? wallet; 

  @override 
  void initState() {
    super.initState();

    _loadWallet(); 
  }

  void _loadWallet() async {
    (String, String) record = await widget.storage.
      readFileAndPass(widget.itemKey); 
    
    wallet = Wallet.fromJson(record.$2, record.$1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
              Padding(padding: EdgeInsetsGeometry.only(left: 10.0)),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20.0,
                alignment: Alignment.topLeft, 
              ), 
          ],
        )
      )  
    ); 
  }
}