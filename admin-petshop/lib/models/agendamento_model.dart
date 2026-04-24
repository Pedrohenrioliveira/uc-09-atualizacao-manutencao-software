class Agendamento {
  final String? id;
  final String nomeTutor;
  final String nomePet;
  final String servico;
  final DateTime dataAgendamento;
  final String telefone;
  final DateTime dataCriacao;

  Agendamento({
    this.id,
    required this.nomeTutor,
    required this.nomePet,
    required this.servico,
    required this.dataAgendamento,
    required this.telefone,
    required this.dataCriacao,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) => Agendamento(
    id: json['id']?.toString(),
    nomeTutor: json['nomeTutor'] ?? '',
    nomePet: json['nomePet'] ?? '',
    servico: json['servico'] ?? '',
    dataAgendamento: json['dataAgendamento'] != null ? DateTime.parse(json['dataAgendamento']) : DateTime.now(),
    telefone: json['telefone'] ?? '',
    dataCriacao: json['dataCriacao'] != null ? DateTime.parse(json['dataCriacao']) : DateTime.now(),
  );
}
