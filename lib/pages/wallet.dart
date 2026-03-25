import 'package:flutter/material.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/core/sqlite_manager.dart';
import 'package:web3dart/web3dart.dart'; 

class WalletPage extends StatefulWidget {
  final SecureStorage storage = SecureStorage(); 
  final Map<String, dynamic> wallet; 
  final String pass; 
  final String email; 

  WalletPage({super.key, required this.wallet, required this.pass, required this.email});

  @override
  State<StatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  SqliteManager? sqlite; 
  Wallet? wallet;

  @override 
  void initState() {
    super.initState();

    _loadWallet(); 
  }

  void _loadWallet() async {
    final wallet_js = widget.wallet['wallet_json']; 
    wallet = Wallet.fromJson(wallet_js, widget.pass);
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
                /* Pop the AlertDialog */
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