import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagem {
  String idUsuario;
  String mensagem;
  String urlImagem;
  String tipo;
  DateTime dataEnvio;

  Mensagem({
    required this.idUsuario,
    required this.mensagem,
    required this.urlImagem,
    required this.tipo,
    required this.dataEnvio,
  });
  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'mensagem': mensagem,
      'urlImagem': urlImagem,
      'tipo': tipo,
      'dataEnvio': Timestamp.fromDate(dataEnvio)
    };
  }
}
