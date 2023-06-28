import 'package:flutter/material.dart';
//Screens
import 'package:app_bioauth_klikticket/src/screens/auth_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// Este Widget le da inicio a la aplicacion.

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Autenticacion local',
      home: AuthScreen(),
    );
  }
}
