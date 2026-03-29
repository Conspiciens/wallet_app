import 'package:flutter/material.dart';
import 'package:wallet/wallet.dart';
import 'package:wallet_app/core/connection_manager.dart';
import 'package:wallet_app/core/rpc_server.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/core/sqlite_manager.dart';
import 'package:wallet_app/widgets/livemenu.dart';
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
  double font_size_title = 14; 
  double font_size_indictator = 18;

  SqliteManager? sqlite; 
  Wallet? wallet;

  String? price; 

  @override 
  void initState() {
    super.initState();

    _loadWallet(); 
  }

  void _loadWallet() {
    final wallet_js = widget.wallet['wallet_json']; 
    setState(() {
      wallet = Wallet.fromJson(wallet_js, widget.pass);
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsetsGeometry.only(left: 0.0)),
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
              ]
            ),
            Padding(padding: EdgeInsetsGeometry.only(top: 20.0)), 
            liveChart(), 
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsetsGeometry.only(top: 100.0)),
                Column(
                  children: [
                    Text("Price", 
                      style: TextStyle(
                        fontSize: font_size_title,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    Text("30.0", 
                      style: TextStyle(
                        fontSize: font_size_indictator, 
                        color: Colors.deepPurple, 
                        fontWeight: FontWeight.bold
                      )
                    ), 
                  ]
                ),
                SizedBox(width: 100.0, height: 0.0), 
                Column( 
                  children: [
                      Text("Market Value", 
                        style: TextStyle(
                          fontSize: font_size_title
                        ),
                      ),
                      Text("30.0")
                  ] 
                ), 
                // Padding(padding: EdgeInsets.only(right: 0.0))
              ] 
            ), 
            ElevatedButton(
              onPressed: () async {
                ConnectionManager manager = ConnectionManager();  
                WalletInfo walletInfo = WalletInfo(ethClient: manager.client);
                EthereumAddress addr = EthereumAddress.fromHex(wallet!.privateKey.address.with0x); 
                EtherAmount amount = await walletInfo.getBalance(addr); 
                setState(() {
                  price = amount.getInEther.toString();
                }); 
              },
              child: const Text("Get Balance", 
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.black
                ),
              ) 
            ), 
          ],
        )
      )  
    ); 
  }
}