import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';

class CaixaDeMensagens extends StatefulWidget {
  const CaixaDeMensagens({super.key, required this.contato});

  final Contato contato;

  @override
  State<CaixaDeMensagens> createState() => _CaixaDeMensagensState();
}

class _CaixaDeMensagensState extends State<CaixaDeMensagens> {
  final Controller _controller = Controller();

  @override
  void initState() {
    super.initState();
    _controller.recuperarDadosUsuario();
    _controller.definirUsuarioDestinatario(widget.contato.idUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Mensagem',
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions_rounded)),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file)),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.credit_card),
                      // ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                    ],
                  ),
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
                controller: _controller.mensagemEditingController,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              _controller.enviarMensagem();
            },
            backgroundColor: Colors.green,
            mini: true,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
