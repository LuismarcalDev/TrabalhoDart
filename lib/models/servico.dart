class Servico {
  final int? id;
  final String descricao;
  double _valor;

  Servico({
    this.id,
    required this.descricao,
    required double valor,
  })  : _valor = valor >= 0
            ? valor
            : throw ArgumentError('O valor do serviço não pode ser negativo');

  double get valor => _valor;

  set valor(double novoValor) {
    if (novoValor < 0) {
      throw ArgumentError('O valor do serviço não pode ser negativo');
    }
    _valor = novoValor;
  }

  void reajustarValor(double percentual) {
    final novoValor = _valor + (_valor * (percentual / 100));
    if (novoValor < 0) {
      throw ArgumentError('O reajuste resultaria em um valor negativo.');
    }
    _valor = novoValor;
  }

  Servico copyWith({
    int? id,
    String? descricao,
    double? valor,
  }) {
    return Servico(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      valor: valor ?? _valor,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'descricao': descricao,
      'valor': _valor,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Servico.fromMap(Map<String, dynamic> map) {
    return Servico(
      id: map['id'] as int?,
      descricao: map['descricao'] as String,
      valor: (map['valor'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'Servico(id: $id, descricao: $descricao, valor: $_valor)';
}
