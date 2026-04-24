class Depoimento {
  final String? id;
  final String nomeCliente;
  final String texto;
  final String caminhoFoto;

  Depoimento({this.id, required this.nomeCliente, required this.texto, required this.caminhoFoto});

  factory Depoimento.fromJson(Map<String, dynamic> json) => Depoimento(
    id: json['id']?.toString(),
    nomeCliente: json['nomeCliente'] ?? '',
    texto: json['texto'] ?? '',
    caminhoFoto: json['caminhoFoto'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'nomeCliente': nomeCliente,
    'texto': texto,
    'caminhoFoto': caminhoFoto,
  };
}
