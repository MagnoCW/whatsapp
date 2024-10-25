import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/screens/mensagens/lista_de_mensagens.dart';

class MensagensStream extends StatefulWidget {
  const MensagensStream({super.key, required this.contato});

  final Contato contato;

  @override
  State<MensagensStream> createState() => _MensagensStreamState();
}

class _MensagensStreamState extends State<MensagensStream> {
  final Controller _controller = Controller();
  @override
  void initState() {
    super.initState();
    _controller.recuperarDadosUsuario();
    _controller.definirUsuarioDestinatario(widget.contato.idUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _controller.recuperarMensagens(
            _controller.idUsuarioLogado!, _controller.idUsuarioDestinatario!),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Expanded(child: Text('Erro ao carregar os dados'));
              } else {
                return ListaDeMensagens(
                  contato: widget.contato,
                );
              }
          }
        });
  }
}
