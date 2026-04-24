class Contato {
  final String? id;
  final String nome;
  final String email;
  final String mensagem;
  final DateTime data;

  Contato({this.id, required this.nome, required this.email, required this.mensagem, required this.data});

  factory Contato.fromJson(Map<String, dynamic> json) => Contato(
    id: json['id']?.toString(),
    nome: json['nome'] ?? '',
    email: json['email'] ?? '',
    mensagem: json['mensagem'] ?? '',
    data: json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
  );
}
