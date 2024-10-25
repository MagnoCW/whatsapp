import 'package:flutter/material.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/screens/mensagens/caixa_de_mensagens.dart';
import 'package:whatsapp/screens/mensagens/mensagens_stream.dart';

class Mensagens extends StatefulWidget {
  const Mensagens({super.key, required this.contato});

  final Contato contato;

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -12,
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 18,
              backgroundImage: widget.contato.caminhoFoto.isNotEmpty
                  ? NetworkImage(widget.contato.caminhoFoto)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              widget.contato.nome,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/images/bg.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MensagensStream(
                contato: widget.contato,
              ),
              CaixaDeMensagens(
                contato: widget.contato,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
