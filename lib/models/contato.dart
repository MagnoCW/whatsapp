class Contato {
  String idUsuario;
  String nome;
  String email;
  String caminhoFoto;

  Contato(
      {required this.idUsuario,
      required this.nome,
      required this.email,
      required this.caminhoFoto});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'idUsuario': idUsuario,
  //     'nome': nome,
  //     'email': email,
  //     'caminhoFoto': caminhoFoto,
  //   };
  // }
}
