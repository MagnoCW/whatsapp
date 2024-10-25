import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      home: StreamBuilder<List<Contato>>(
          stream: Controller().recuperarContatos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum contato encontrado.'));
            }

            final contato = snapshot.data!.first; // Pegando o primeiro contato
            return Login(
              contato: contato,
            );
          }),
    );
  }
}
