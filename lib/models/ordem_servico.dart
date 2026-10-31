import 'funcionario.dart';
import 'veiculo.dart';
import 'status.dart';
import 'ordem_servico_servico.dart';

class OrdemServico {
  final int? id;
  final int? funcionarioId;
  final Funcionario? funcionario;
  final int? veiculoId;
  final Veiculo? veiculo;
  final int? statusId;
  Status? _status;
  final String dataEntrada;
  final List<OrdemServicoServico> _servicos;

  OrdemServico({
    this.id,
    this.funcionarioId,
    this.funcionario,
    this.veiculoId,
    this.veiculo,
    this.statusId,
    Status? status,
    required this.dataEntrada,
    List<OrdemServicoServico>? servicos,
  }) : _servicos = servicos != null ? List.from(servicos) : [] {
    if (status != null) {
      alterarStatus(status);
    }
  }

  Status? get status => _status;

  set status(Status? novoStatus) {
    if (novoStatus != null) {
      alterarStatus(novoStatus);
    } else {
      _status = null;
    }
  }

  List<OrdemServicoServico> get servicos => List.unmodifiable(_servicos);

  void alterarStatus(Status novoStatus) {
    final descricao = novoStatus.descricao.trim().toLowerCase();
    if (descricao.contains('conclu') && _servicos.isEmpty) {
      throw StateError(
        'Um atendimento não poderá ser concluído sem possuir pelo menos um trabalho.',
      );
    }
    _status = novoStatus;
  }

  void concluir([Status? statusConcluido]) {
    final statusFinal =
        statusConcluido ?? const Status(descricao: 'Concluído');
    alterarStatus(statusFinal);
  }

  void adicionarServico(OrdemServicoServico item) {
    _servicos.add(item);
  }

  bool removerServico(OrdemServicoServico item) {
    return _servicos.remove(item);
  }

  double calcularTotal() {
    return _servicos.fold<double>(
      0.0,
      (acumulado, item) => acumulado + item.valorPago,
    );
  }

  double get total => calcularTotal();

  OrdemServico copyWith({
    int? id,
    int? funcionarioId,
    Funcionario? funcionario,
    int? veiculoId,
    Veiculo? veiculo,
    int? statusId,
    Status? status,
    List<OrdemServicoServico>? servicos,
  }) {
    final novosServicos =
        servicos != null ? List<OrdemServicoServico>.from(servicos) : _servicos;
    final novoStatus = status ?? _status;

    if (novoStatus != null) {
      final desc = novoStatus.descricao.trim().toLowerCase();
      if (desc.contains('conclu') && novosServicos.isEmpty) {
        throw StateError(
          'Um atendimento não poderá ser concluído sem possuir pelo menos um trabalho.',
        );
      }
    }

    return OrdemServico(
      id: id ?? this.id,
      funcionarioId: funcionarioId ??
          this.funcionarioId ??
          (funcionario ?? this.funcionario)?.id,
      funcionario: funcionario ?? this.funcionario,
      veiculoId: veiculoId ?? this.veiculoId ?? (veiculo ?? this.veiculo)?.id,
      veiculo: veiculo ?? this.veiculo,
      statusId: statusId ?? this.statusId ?? novoStatus?.id,
      status: novoStatus,
      dataEntrada: dataEntrada,
      servicos: novosServicos,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'funcionario_id': funcionarioId ?? funcionario?.id,
      'veiculo_id': veiculoId ?? veiculo?.id,
      'status_id': statusId ?? _status?.id,
      'data_entrada': dataEntrada,
      'servicos': _servicos.map((s) => s.toMap()).toList(),
    };
    if (id != null) map['id'] = id;
    if (funcionario != null) map['funcionario'] = funcionario!.toMap();
    if (veiculo != null) map['veiculo'] = veiculo!.toMap();
    if (_status != null) map['status'] = _status!.toMap();
    return map;
  }

  factory OrdemServico.fromMap(Map<String, dynamic> map) {
    Funcionario? funcionarioObj;
    if (map['funcionario'] != null &&
        map['funcionario'] is Map<String, dynamic>) {
      funcionarioObj =
          Funcionario.fromMap(map['funcionario'] as Map<String, dynamic>);
    }

    Veiculo? veiculoObj;
    if (map['veiculo'] != null && map['veiculo'] is Map<String, dynamic>) {
      veiculoObj = Veiculo.fromMap(map['veiculo'] as Map<String, dynamic>);
    }

    Status? statusObj;
    if (map['status'] != null && map['status'] is Map<String, dynamic>) {
      statusObj = Status.fromMap(map['status'] as Map<String, dynamic>);
    }

    List<OrdemServicoServico> servicosList = [];
    if (map['servicos'] != null && map['servicos'] is List) {
      servicosList = (map['servicos'] as List)
          .map((item) =>
              OrdemServicoServico.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return OrdemServico(
      id: map['id'] as int?,
      funcionarioId: (map['funcionario_id'] ?? map['Funcionario_id']) as int?,
      funcionario: funcionarioObj,
      veiculoId: (map['veiculo_id'] ?? map['Veiculo_id']) as int?,
      veiculo: veiculoObj,
      statusId: (map['status_id'] ?? map['Status_id']) as int?,
      status: statusObj,
      dataEntrada: (map['data_entrada'] ?? map['dataEntrada']) as String,
      servicos: servicosList,
    );
  }

  @override
  String toString() =>
      'OrdemServico(id: $id, dataEntrada: $dataEntrada, status: ${_status?.descricao}, total: ${calcularTotal().toStringAsFixed(2)}, funcionario: ${funcionario?.nome}, veiculo: ${veiculo?.modelo}, qtdServicos: ${_servicos.length})';
}
