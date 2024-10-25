import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final Controller _controller = Controller();
  bool isLoading = false;

  Future<void> _recuperarImagem(String origemImagem) async {
    XFile? imagemSelecionada;

    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
            await ImagePicker().pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        break;
    }

    if (imagemSelecionada != null) {
      File arquivoImagem = File(imagemSelecionada.path);

      // Atualizando o estado do controller
      setState(() {
        _controller.imagem = arquivoImagem;
        isLoading = true; // Atualiza a imagem no controller
      });

      // Chamando o upload após a atualização do estado
      await _controller.uploadImagem(_atualizaImagem); // Faz o upload da imagem
      setState(() {
        isLoading = false; // Finaliza o carregamento
      });
    }
  }

  void _atualizaImagem(String? url) {
    setState(() {
      _controller.urlImagemRecuperada = url; // Atualiza a URL
    });
  }

  Future<void> _recuperarDadosUsuario() async {
    await _controller.recuperarDadosUsuario();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const AppBarTheme().backgroundColor,
        title: const Text('Configurações'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CircleAvatar(
                    maxRadius: 100, child: CircularProgressIndicator())
                : CircleAvatar(
                    maxRadius: 100,
                    backgroundImage: _controller.urlImagemRecuperada != null
                        ? NetworkImage(_controller.urlImagemRecuperada!)
                        : null),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      _recuperarImagem("camera");
                    },
                    child: const Text(
                      'Câmera',
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () {
                      _recuperarImagem("galeria");
                    },
                    child: const Text(
                      'Galeria',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            TextField(
              controller: _controller.nomeEditingController,
              onChanged: (texto) {
                _controller.atualizarNomePerfil(texto);
              },
              decoration: InputDecoration(
                hintText: _controller.nomeEditingController.text,
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
            ),
          ],
        ),
      ),
    );
  }
}
