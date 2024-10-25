import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/models/mensagem.dart';

class ListaDeMensagens extends StatefulWidget {
  const ListaDeMensagens({
    super.key,
    required this.contato,
  });

  final Contato contato;

  @override
  State<ListaDeMensagens> createState() => _ListaDeMensagensState();
}

class _ListaDeMensagensState extends State<ListaDeMensagens> {
  final Controller _controller = Controller();
  late Stream<List<Mensagem>> _mensagensStream; // Para armazenar as mensagens

  @override
  void initState() {
    super.initState();
    _controller.recuperarDadosUsuario();
    // _controller.definirUsuarioDestinatario(widget.contato.idUsuario);

    // Recupera as mensagens para o contato
    _mensagensStream = _controller.recuperarMensagens(
      _controller.idUsuarioLogado!,
      widget.contato.idUsuario,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Mensagem>>(
        stream: _mensagensStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar mensagens: ${snapshot.error}'));
          }

          final mensagens = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: mensagens.length,
            itemBuilder: (context, index) {
              final mensagem = mensagens[index];
              final bool usuario =
                  _controller.idUsuarioLogado == mensagem.idUsuario;

              return Align(
                alignment:
                    usuario ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: usuario ? Colors.green[300] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    mensagem.mensagem,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
