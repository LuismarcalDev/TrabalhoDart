import 'servico.dart';

class OrdemServicoServico {
  final int? ordemServicoId;
  final int? servicoId;
  final Servico? servico;
  double _valorPago;

  OrdemServicoServico({
    this.ordemServicoId,
    this.servicoId,
    this.servico,
    required double valorPago,
  })  : _valorPago = valorPago >= 0
            ? valorPago
            : throw ArgumentError('O valor pago não pode ser negativo');

  factory OrdemServicoServico.fromServico(
    Servico servico, {
    int? ordemServicoId,
    double? valorPago,
  }) {
    return OrdemServicoServico(
      ordemServicoId: ordemServicoId,
      servicoId: servico.id,
      servico: servico,
      valorPago: valorPago ?? servico.valor,
    );
  }

  double get valorPago => _valorPago;

  set valorPago(double novoValor) {
    if (novoValor < 0) {
      throw ArgumentError('O valor pago não pode ser negativo');
    }
    _valorPago = novoValor;
  }

  void reajustarValorPago(double percentual) {
    final novoValor = _valorPago + (_valorPago * (percentual / 100));
    if (novoValor < 0) {
      throw ArgumentError('O reajuste resultaria em um valor negativo.');
    }
    _valorPago = novoValor;
  }

  OrdemServicoServico copyWith({
    int? ordemServicoId,
    int? servicoId,
    Servico? servico,
    double? valorPago,
  }) {
    return OrdemServicoServico(
      ordemServicoId: ordemServicoId ?? this.ordemServicoId,
      servicoId: servicoId ?? this.servicoId ?? (servico ?? this.servico)?.id,
      servico: servico ?? this.servico,
      valorPago: valorPago ?? _valorPago,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'ordem_servico_id': ordemServicoId,
      'servico_id': servicoId ?? servico?.id,
      'valor_pago': _valorPago,
    };
    if (servico != null) {
      map['servico'] = servico!.toMap();
    }
    return map;
  }

  factory OrdemServicoServico.fromMap(Map<String, dynamic> map) {
    Servico? servicoObj;
    if (map['servico'] != null && map['servico'] is Map<String, dynamic>) {
      servicoObj = Servico.fromMap(map['servico'] as Map<String, dynamic>);
    }

    return OrdemServicoServico(
      ordemServicoId:
          (map['ordem_servico_id'] ?? map['OrdemServico_id']) as int?,
      servicoId: (map['servico_id'] ?? map['Servico_id']) as int?,
      servico: servicoObj,
      valorPago:
          ((map['valor_pago'] ?? map['valorPago'] ?? 0) as num).toDouble(),
    );
  }

  @override
  String toString() =>
      'OrdemServicoServico(ordemServicoId: $ordemServicoId, servicoId: ${servicoId ?? servico?.id}, valorPago: $_valorPago, servico: ${servico?.descricao})';
}
