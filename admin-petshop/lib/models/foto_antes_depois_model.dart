class FotoAntesDepois {
  final int id;
  final String nomeCachorro;
  final String caminhoFotoAntes;
  final String caminhoFotoDepois;
  final String? linkRedeSocial;
  final DateTime dataCriacao;

  FotoAntesDepois({
    required this.id,
    required this.nomeCachorro,
    required this.caminhoFotoAntes,
    required this.caminhoFotoDepois,
    this.linkRedeSocial,
    required this.dataCriacao,
  });

  factory FotoAntesDepois.fromJson(Map<String, dynamic> json) {
    return FotoAntesDepois(
      id: json['id'],
      nomeCachorro: json['nomeCachorro'],
      caminhoFotoAntes: json['caminhoFotoAntes'],
      caminhoFotoDepois: json['caminhoFotoDepois'],
      linkRedeSocial: json['linkRedeSocial'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCachorro': nomeCachorro,
      'caminhoFotoAntes': caminhoFotoAntes,
      'caminhoFotoDepois': caminhoFotoDepois,
      'linkRedeSocial': linkRedeSocial,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }
}
