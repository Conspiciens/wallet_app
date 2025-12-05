import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:wallet_app/pages/wallets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); 

  @override
  State<LoginPage> createState() => _LoginPageState(); 
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsetsGeometry.only(top: 40.0)),
              Text(
                'CrytoManager',
              ), 
              Padding(padding: const EdgeInsetsGeometry.only(top: 20.0)), 
              SupaEmailAuth(
                onSignInComplete: (response) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WalletsPage())
                  ); 
                }, 
                onSignUpComplete: (response) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WalletsPage())
                  ); 
                },  
              ),
            ] 
          )
        ),
      ),  
    ); 
  }
}
