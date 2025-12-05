import 'package:flutter/material.dart';
import 'package:wallet_app/core/keys_manager.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/core/wallet_manager.dart';
import 'package:web3dart/web3dart.dart'; 

class NewWallet extends StatefulWidget {

  const NewWallet({super.key}); 

  @override
  State<NewWallet> createState() => _NewWalletState(); 
}

class _NewWalletState extends State<NewWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SelectNewOrUploadWallet() 
      ) 
    ); 
  }
}

class SelectNewOrUploadWallet extends StatefulWidget {

  const SelectNewOrUploadWallet({super.key}); 

  @override
  State<SelectNewOrUploadWallet> createState() => _SelectNewOrUploadWalletState(); 
}

class _SelectNewOrUploadWalletState extends State<SelectNewOrUploadWallet> {
  final List<bool> _walletOptions = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return 
      Column(
        children: [
          Row(
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
            ] 
          ),
          ToggleButtons(
            direction: Axis.horizontal,
            isSelected: _walletOptions, 
            borderRadius: BorderRadius.circular(20.0),
            borderWidth: 0.5,
            borderColor: Colors.blue,
            selectedBorderColor: Colors.lightBlue,
            onPressed: (int idx) {
              setState(() {
                for (int buttonIdx = 0; buttonIdx < _walletOptions.length; buttonIdx++) {
                  if (buttonIdx == idx) {
                    _walletOptions[buttonIdx] = !_walletOptions[buttonIdx];
                  } else {
                    _walletOptions[buttonIdx] = false;
                  }
                }
              });
            },
            children: <Widget>[
              Text("Create Wallet"), 
              Text("Upload Wallet")
            ]
          ), 
          _walletOptions[0] ? WalletForm() : WalletUpload()
        ]
      );
  }
}

class WalletForm extends StatefulWidget {

  const WalletForm({super.key}); 

  @override 
  State<WalletForm> createState() => _WalletFormState(); 
}

class _WalletFormState extends State<WalletForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>(); 
  final OutlineInputBorder borderRoundness = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
  ); 
  KeysManager? keys;
  final SecureStorage storage = SecureStorage(); 
  final TextEditingController walletName = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKeys(); 
  }

  void _loadKeys() {
    KeysManager.getInstance().then(
      (value) => keys = value);
    
    if (keys == null) { return; }
    keys?.loadKeys();
  }

  @override
  void dispose() {
    super.dispose();

    walletName.dispose(); 
    password.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsetsGeometry.only(top: 20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  controller: walletName,
                  decoration: InputDecoration(
                    border: borderRoundness,
                    filled: true, 
                    hintText: "Name of Wallet",
                    labelText: "Name Of Wallet",
                    helperText: "Name of Wallet",
                    fillColor: Colors.white70
                  ),
                ), 
              ),
              SizedBox(
                width: 350.0, 
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    border: borderRoundness, 
                    filled: true, 
                    hintText: "Enter you password", 
                    labelText: "Enter your password", 
                    helperText: "Enter your password", 
                    fillColor: Colors.white70
                  ),
                )
              )
            ],
          ), 
          Padding(padding: EdgeInsetsGeometry.only(top: 20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  if (keys == null) { 
                    return; 
                  }

                  /* Add key */ 
                  String? key = await keys?.addKey(); 

                  if (key == null) { return; }

                  Wallet wallet = createWallet(password.text); 
                  String jsonString = wallet.toJson(); 

                  await storage.writeFileAndPassStorage(key, 
                    jsonString, password.text);                   

                  if (!context.mounted) { return; } 
                  Navigator.of(context).pop();
                }, 
                child: const Text("Create Wallet") 
              )
            ],  
          )
        ],
      ) 
    ); 
  }
}

class WalletUpload extends StatefulWidget {
  const WalletUpload({super.key}); 

  @override
  State<WalletUpload> createState() => _WalletUploadState(); 
} 

class _WalletUploadState extends State<WalletUpload> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column()
    ); 
  }
} 