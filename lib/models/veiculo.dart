import 'cliente.dart';

class Veiculo {
  final int? id;
  final int? clienteId;
  final Cliente? cliente;
  final String modelo;
  final String marca;
  final int ano;
  final String placa;

  const Veiculo({
    this.id,
    this.clienteId,
    this.cliente,
    required this.modelo,
    required this.marca,
    required this.ano,
    required this.placa,
  });

  Veiculo copyWith({
    int? id,
    int? clienteId,
    Cliente? cliente,
    String? modelo,
    String? marca,
    int? ano,
  }) {
    return Veiculo(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId ?? (cliente ?? this.cliente)?.id,
      cliente: cliente ?? this.cliente,
      modelo: modelo ?? this.modelo,
      marca: marca ?? this.marca,
      ano: ano ?? this.ano,
      placa: placa,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'cliente_id': clienteId ?? cliente?.id,
      'modelo': modelo,
      'marca': marca,
      'ano': ano,
      'placa': placa,
    };
    if (id != null) map['id'] = id;
    if (cliente != null) {
      map['cliente'] = cliente!.toMap();
    }
    return map;
  }

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    Cliente? clienteObj;
    if (map['cliente'] != null && map['cliente'] is Map<String, dynamic>) {
      clienteObj = Cliente.fromMap(map['cliente'] as Map<String, dynamic>);
    }

    return Veiculo(
      id: map['id'] as int?,
      clienteId: (map['cliente_id'] ?? map['Cliente_id']) as int?,
      cliente: clienteObj,
      modelo: map['modelo'] as String,
      marca: map['marca'] as String,
      ano: (map['ano'] as num).toInt(),
      placa: map['placa'] as String,
    );
  }

  @override
  String toString() =>
      'Veiculo(id: $id, modelo: $modelo, marca: $marca, ano: $ano, placa: $placa, clienteId: ${clienteId ?? cliente?.id})';
}
