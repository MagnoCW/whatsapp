import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/models/mensagem.dart';

class Controller {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController nomeEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController senhaEditingController = TextEditingController();
  final TextEditingController repetirSenhaEditingController =
      TextEditingController();
  final TextEditingController mensagemEditingController =
      TextEditingController();
  File? imagem;
  String? idUsuarioLogado;
  String? emailUsuarioLogado;
  String? idUsuarioDestinatario;
  final List<String> itensMenu = ['Configurações', 'Deslogar'];
  final String perfil1 = 'lib/images/perfil1.jpg';
  final String perfil2 = 'lib/images/perfil2.jpg';
  final String perfil3 = 'lib/images/perfil3.jpg';
  final String perfil4 = 'lib/images/perfil4.jpg';
  final String perfil5 = 'lib/images/perfil5.jpg';

  String? urlImagemRecuperada;

  String? validarCamposCadastro() {
    if (nomeEditingController.text.isEmpty ||
        emailEditingController.text.isEmpty ||
        senhaEditingController.text.isEmpty ||
        repetirSenhaEditingController.text.isEmpty) {
      return 'Todos os campos são obrigatórios!';
    }
    return null;
  }

  String? validarCamposLogin() {
    if (emailEditingController.text.isEmpty ||
        senhaEditingController.text.isEmpty) {
      return 'Todos os campos são obrigatórios!';
    }
    return null;
  }

  String? validarSenha() {
    if (senhaEditingController.text != repetirSenhaEditingController.text) {
      return 'Os campos senha e Repetir Senha estão diferentes!';
    }
    return null;
  }

  Future<void> cadastrarConta({
    required Function(User) onSuccess,
    required Function(String) onError,
  }) async {
    final erroValidarCampos = validarCamposCadastro();
    if (erroValidarCampos != null) {
      onError(erroValidarCampos);
      return;
    }
    final erroValidarSenha = validarSenha();
    if (erroValidarSenha != null) {
      onError(erroValidarSenha);
      return;
    }
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailEditingController.text.trim(),
        password: senhaEditingController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(nomeEditingController.text);
        await recuperarDadosUsuario();
        await adicionarUserDB();
        onSuccess(user);
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'Erro desconhecido');
    } catch (e) {
      onError('Erro ao criar a conta: ${e.toString()}');
    } finally {
      limparControllers();
    }
  }

  Future<void> logarConta({
    required Function(User) onSuccess,
    required Function(String) onError,
  }) async {
    final erroValidarCampos = validarCamposLogin();
    if (erroValidarCampos != null) {
      onError(erroValidarCampos);
      return;
    }
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailEditingController.text.trim(),
        password: senhaEditingController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        await recuperarDadosUsuario();
        onSuccess(user);
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      limparControllers();
    }
  }

  void limparControllers() {
    nomeEditingController.clear();
    emailEditingController.clear();
    senhaEditingController.clear();
    repetirSenhaEditingController.clear();
  }

  Future<void> recuperarDadosUsuario() async {
    User? usuarioLogado = auth.currentUser;

    // Verifique se o usuário está logado
    if (usuarioLogado == null) {
      // Trate o caso em que não há usuário logado (pode lançar um erro, exibir uma mensagem, etc.)
      print("Nenhum usuário logado.");
      return; // Retorna para evitar continuar a execução
    }

    idUsuarioLogado = usuarioLogado.uid;
    emailUsuarioLogado = usuarioLogado.email;

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuarios').doc(idUsuarioLogado).get();

    // Utilize o operador de coalescência nula para evitar que o código falhe se `dados` for null
    Map<String, dynamic>? dados = snapshot.data();

    // Verifique se `dados` não é null antes de acessá-lo
    if (dados != null) {
      nomeEditingController.text =
          dados['nome'] ?? ''; // Use um valor padrão se 'nome' não existir
      if (dados['urlImagem'] != null) {
        urlImagemRecuperada = dados['urlImagem'];
      }
    } else {
      print("Nenhum dado encontrado para o usuário: $idUsuarioLogado");
    }
  }

  void definirUsuarioDestinatario(String idContato) {
    idUsuarioDestinatario = idContato;
  }

  Future<void> uploadImagem(Function(String?) callback) async {
    try {
      Reference pastaRaiz = FirebaseStorage.instance.ref();
      Reference arquivo =
          pastaRaiz.child("perfil").child("$idUsuarioLogado.jpg");

      // Faz o upload da imagem e aguarda a conclusão
      TaskSnapshot snapshot = await arquivo.putFile(imagem!);

      // Recupera a URL da imagem após o upload
      urlImagemRecuperada = await imagemRecuperada(snapshot);

      callback(urlImagemRecuperada);

      await atualizarPhotoPerfil();

      print(
          "Upload da imagem realizado com sucesso! URL: $urlImagemRecuperada");
    } catch (e) {
      print("Erro ao fazer upload da imagem: $e");
    }
  }

  Future<String> imagemRecuperada(TaskSnapshot snapshot) async {
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> adicionarUserDB() async {
    Map<String, dynamic> userData = {
      'nome': nomeEditingController.text,
      'email': emailEditingController.text,
      'urlImagem': urlImagemRecuperada,
    };
    await db
        .collection('usuarios')
        .doc(idUsuarioLogado)
        .set(userData, SetOptions(merge: true));
  }

  Future<void> atualizarPhotoPerfil() async {
    Map<String, dynamic> userData = {
      'urlImagem': urlImagemRecuperada,
    };
    await db
        .collection('usuarios')
        .doc(idUsuarioLogado)
        .set(userData, SetOptions(merge: true));
  }

  Future<void> atualizarNomePerfil(String nome) async {
    Map<String, dynamic> userData = {
      'nome': nome,
    };
    await db
        .collection('usuarios')
        .doc(idUsuarioLogado)
        .set(userData, SetOptions(merge: true));
  }

  void deslogarUsuario() async {
    try {
      await auth.signOut();
    } catch (e) {
      print("erro ao deslogar: $e");
    }
  }

  Stream<List<Contato>> recuperarContatos() async* {
    QuerySnapshot querySnapshot = await db.collection('usuarios').get();

    List<Contato> listaContatos = [];
    String? emailUsuarioLogado = auth.currentUser?.email;

    Contato? usuarioLogado;

    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map<String, dynamic>?; // Cast seguro

      Contato contato = Contato(
        idUsuario: item.id,
        nome: dados?['nome'] ?? 'Nome desconhecido',
        email: dados?['email'] ?? '',
        caminhoFoto: dados?['urlImagem'] ?? '',
      );

      if (dados?['email'] == emailUsuarioLogado) {
        usuarioLogado = Contato(
          idUsuario: contato.idUsuario,
          nome: '${contato.nome} (você)',
          email: contato.email,
          caminhoFoto: contato.caminhoFoto,
        );
      } else {
        listaContatos.add(contato);
      }
    }

    if (usuarioLogado != null) {
      listaContatos.insert(0, usuarioLogado);
    }

    yield listaContatos;
  }

  Future<void> salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());
    mensagemEditingController.clear();
  }

  void enviarMensagem() {
    String textoMensagem = mensagemEditingController.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem(
          idUsuario: idUsuarioLogado!,
          mensagem: textoMensagem,
          urlImagem: "",
          tipo: "texto",
          dataEnvio: DateTime.now());
      if (idUsuarioLogado! == idUsuarioDestinatario) {
        salvarMensagem(idUsuarioLogado!, idUsuarioDestinatario!, mensagem);
      } else {
        salvarMensagem(idUsuarioLogado!, idUsuarioDestinatario!, mensagem);
        salvarMensagem(idUsuarioDestinatario!, idUsuarioLogado!, mensagem);
      }
    }
  }

  Stream<List<Mensagem>> recuperarMensagens(
      String idRemetente, String idDestinatario) {
    return db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .orderBy('dataEnvio',
            descending: false) // As mensagens serão ordenadas por data de envio
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> dados = doc.data();
        return Mensagem(
          idUsuario: dados['idUsuario'],
          mensagem: dados['mensagem'],
          urlImagem: dados['urlImagem'],
          tipo: dados['tipo'],
          dataEnvio: (dados['dataEnvio'] as Timestamp)
              .toDate(), // Convertendo Timestamp para DateTime
        );
      }).toList();
    });
  }

  Stream<Mensagem?> recuperarUltimaMensagem(
      String idRemetente, String idDestinatario) {
    return db
        .collection('mensagens')
        .doc(idDestinatario)
        .collection(idRemetente)
        .orderBy('dataEnvio', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> dados = snapshot.docs.first.data();
        return Mensagem(
          idUsuario: dados['idUsuario'],
          mensagem: dados['mensagem'],
          urlImagem: dados['urlImagem'],
          tipo: dados['tipo'],
          dataEnvio: (dados['dataEnvio'] as Timestamp).toDate(),
        );
      }
      return null;
    });
  }
}
