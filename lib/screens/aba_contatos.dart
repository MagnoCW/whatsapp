import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/screens/mensagens/mensagens.dart';

class AbaContatos extends StatelessWidget {
  AbaContatos({super.key});
  final Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _controller.recuperarContatos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              List<Contato> listaItens = snapshot.data!;
              return ListView.builder(
                itemCount: listaItens.length,
                itemBuilder: (context, index) {
                  Contato contato = listaItens[index];
                  return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mensagens(
                                      contato: contato,
                                    )));
                      },
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        contato.nome,
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundImage: contato.caminhoFoto.isNotEmpty
                            ? NetworkImage(contato.caminhoFoto)
                            : null,
                      ));
                },
              );
          }
        });
  }
}
