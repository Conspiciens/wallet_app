import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/login.dart'; 

void main() async {
  const TYPE = String.fromEnvironment("TYPE"); 
  if (TYPE == "prod") {
    await dotenv.load(fileName: ".env");
  } else {
    await dotenv.load(fileName: ".env.dev");
  }


  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"), 
    anonKey: dotenv.get("SUPABASE_PUBLISHABLE_KEY"),
  ); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
      },
    );
  }
}
