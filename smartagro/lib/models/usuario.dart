class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // Converte JSON em objeto Usuario
  factory Usuario.fromJson(
    Map<String, dynamic> json,
  ) {
    return Usuario(
      id: json['id'],
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
    );
  }

  // Converte objeto Usuario em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}