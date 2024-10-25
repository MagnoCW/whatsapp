import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/screens/cadastro.dart';
import 'package:whatsapp/screens/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.contato});

  final Contato contato;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Controller _controller = Controller();
  final bool _obscureText = true;

  void checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;

    print('Verificando usuário logado...');
    print('Usuário: ${user != null ? user.email : 'Nenhum usuário logado'}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        print('Usuário logado, navegando para HomePage.');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => HomePage(
                    contato: widget.contato,
                  )),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Image.asset('lib/images/logo.png'),
            TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                  ),
                ),
              ),
              controller: _controller.emailEditingController,
            ),
            TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Senha',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Borda arredondada
                  borderSide: const BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Colors.green, // Cor da borda ao focar
                  ),
                ),
              ),
              controller: _controller.senhaEditingController,
            ),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _controller.logarConta(onSuccess: (user) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                contato: widget.contato,
                              )),
                    );
                  }, onError: (erro) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(erro)),
                    );
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Cadastro())).then((_) {
                  setState(() {
                    checkUserLoggedIn();
                  });
                });
              },
              child: const Text(
                'Não tem conta? Cadastre-se!',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
