import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/models/mensagem.dart';
import 'package:whatsapp/screens/mensagens/mensagens.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({super.key, required this.contato});

  final Contato contato;

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  final Controller _controller = Controller();

  @override
  void initState() {
    super.initState();
    _controller.recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Contato>>(
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
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum contato encontrado.'));
            }
            List<Contato> listaItens = snapshot.data!;
            return ListView.builder(
              itemCount: listaItens.length,
              itemBuilder: (context, index) {
                Contato contato = listaItens[index];

                // Usando um StreamBuilder para buscar a última mensagem
                return StreamBuilder<Mensagem?>(
                  stream: _controller.recuperarUltimaMensagem(
                    _controller.idUsuarioLogado!,
                    contato.idUsuario,
                  ),
                  builder: (context, mensagemSnapshot) {
                    String ultimaMensagem = '';

                    if (mensagemSnapshot.hasData) {
                      ultimaMensagem = mensagemSnapshot.data!.mensagem;
                    } else if (mensagemSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      ultimaMensagem = 'Carregando...';
                    } else {
                      ultimaMensagem = 'Sem mensagens.';
                    }

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mensagens(
                              contato: contato,
                            ),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        contato.nome,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        ultimaMensagem,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundImage: contato.caminhoFoto.isNotEmpty
                            ? NetworkImage(contato.caminhoFoto)
                            : null,
                      ),
                    );
                  },
                );
              },
            );
        }
      },
    );
  }
}
