import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final Controller _controller = Controller();
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const AppBarTheme().backgroundColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Image.asset('lib/images/logo.png'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
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
              controller: _controller.nomeEditingController,
            ),
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
            TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Repetir a Senha',
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
              controller: _controller.repetirSenhaEditingController,
            ),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _controller.cadastrarConta(
                    onSuccess: (user) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bem-vindo, ${user.email}!')),
                      );
                      Navigator.pop(context);
                    },
                    onError: (erro) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(erro)),
                      );
                    },
                  );
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
