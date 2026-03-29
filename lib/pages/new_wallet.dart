import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:wallet_app/core/secure_storage.dart';
import 'package:wallet_app/core/sqlite_manager.dart';
import 'package:wallet_app/core/wallet_manager.dart';
import 'package:web3dart/web3dart.dart'; 
import 'package:uuid/uuid.dart';

class NewWallet extends StatefulWidget {
  final String email; 

  const NewWallet({super.key, required this.email}); 

  @override
  State<NewWallet> createState() => _NewWalletState(); 
}

class _NewWalletState extends State<NewWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SelectNewOrUploadWallet(email: widget.email) 
      ) 
    ); 
  }
}

class SelectNewOrUploadWallet extends StatefulWidget {
  final String email; 

  const SelectNewOrUploadWallet({super.key, required this.email}); 

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
            borderRadius: BorderRadius.circular(15.0),
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
              const Padding( 
                padding: EdgeInsets.all(10.0), 
                child: Text("Create Wallet", 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.black,
                  )
                ), 
              ), 
              const Padding(
                padding: EdgeInsetsGeometry.all(10.0), 
                child: Text("Upload Wallet", 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.black
                  )
                )
              )
            ]
          ), 
          _walletOptions[0] ? WalletForm(email: widget.email) : WalletUpload(email: widget.email)
        ]
      );
  }
}

class WalletForm extends StatefulWidget {
  final String email; 

  const WalletForm({super.key, required this.email}); 

  @override 
  State<WalletForm> createState() => _WalletFormState(); 
}

class _WalletFormState extends State<WalletForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>(); 
  final OutlineInputBorder borderRoundness = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
  ); 
  SqliteManager? sqlite; 
  final SecureStorage storage = SecureStorage(); 
  final TextEditingController walletName = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKeys(); 
  }

  Future<void> _loadKeys() async  {
    print("Loading keys..."); 
    String? pass = await storage.readStorage(widget.email); 
    if (pass == null) return; 

    SqliteManager manager = await SqliteManager.create(pass);
    setState(() {
      sqlite = manager; 
    });
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
                    fillColor: Colors.white70
                  ),
                ), 
              ),
            ],
          ),
          Padding(padding: EdgeInsetsGeometry.only(top: 20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 350.0, 
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    border: borderRoundness, 
                    filled: true, 
                    hintText: "Enter you password", 
                    labelText: "Enter your password", 
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
                  print("Creaing new wallet..."); 
                  Wallet wallet = createWallet(password.text); 
                  String jsonString = wallet.toJson(); 

                  final salt = BCrypt.gensalt(); 
                  final passHash = BCrypt.hashpw(password.text, salt); 

                  final uuid = Uuid(); 
                  var u4 = uuid.v4(); 

                  if (sqlite == null) return;                 
                  print("Loading Creds.."); 
                  await sqlite?.storeWallet(u4, walletName.text, jsonString); 
                  await SecureStorage().passStorageOrStoreWalletpass(u4, passHash, true); 

                  print("Initialized " + walletName.text); 

                  if (!context.mounted) { return; } 
                  Navigator.of(context).pop();
                }, 
                child: const Text("Create Wallet", 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.black
                  ),
                ) 
              )
            ],  
          )
        ],
      ) 
    ); 
  }
}

class WalletUpload extends StatefulWidget {
  final String email; 
  const WalletUpload({super.key, required this.email}); 

  @override
  State<WalletUpload> createState() => _WalletUploadState(); 
} 

class _WalletUploadState extends State<WalletUpload> {
  SqliteManager? sqlite; 
  SecureStorage storage = SecureStorage(); 
  final OutlineInputBorder borderRoundness = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
  ); 
  TextEditingController walletName = TextEditingController(); 
  TextEditingController walletPrivateKey = TextEditingController(); 
  TextEditingController password = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _loadKeys(); 
  }

  Future<void> _loadKeys() async  {
    print("Loading keys..."); 
    String? pass = await storage.readStorage(widget.email); 
    if (pass == null) return; 

    SqliteManager manager = await SqliteManager.create(pass);
    setState(() {
      sqlite = manager; 
    });
  }

  @override
  void dispose() {
    super.dispose(); 

    walletPrivateKey.dispose(); 
    walletName.dispose(); 
    password.dispose(); 
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  controller: walletName,
                  decoration: InputDecoration(
                    border: borderRoundness,
                    filled: true, 
                    hintText: "Name of Wallet",
                    labelText: "Name Of Wallet",
                    fillColor: Colors.white70
                  ),
                ), 
              ),
            ],
          ), 
          Row(
            children: [
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  controller: walletPrivateKey,
                  decoration: InputDecoration(
                    border: borderRoundness,
                    filled: true, 
                    hintText: "Wallet Private Key",
                    labelText: "Wallet Private Key",
                    fillColor: Colors.white70
                  ),
                ), 
              ),
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 350.0, 
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    border: borderRoundness, 
                    filled: true, 
                    hintText: "Enter you password", 
                    labelText: "Enter your password", 
                    fillColor: Colors.white70
                  ),
                )
              )
            ] 
          ), 
          Padding(padding: EdgeInsetsGeometry.only(top: 20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  print("Creaing json file from existing Wallet..."); 
                  Wallet wallet = existingWalletHex(password.text, walletPrivateKey.text); 
                  String jsonString = wallet.toJson(); 

                  final salt = BCrypt.gensalt(); 
                  final passHash = BCrypt.hashpw(password.text, salt); 

                  final uuid = Uuid(); 
                  var u4 = uuid.v4(); 

                  if (sqlite == null) return;                 
                  print("Loading Creds.."); 
                  await sqlite?.storeWallet(u4, walletName.text, jsonString); 
                  await SecureStorage().passStorageOrStoreWalletpass(u4, passHash, true); 

                  print("Initialized " + walletName.text); 

                  if (!context.mounted) { return; } 
                  Navigator.of(context).pop();
                }, 
                child: const Text("Create Existing Wallet", 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.black
                  ),
                ) 
              )
            ],  
          )
        ],
      )
    ); 
  }
} 