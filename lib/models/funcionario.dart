class Funcionario {
  final int? id;
  final String nome;
  final String cpf;
  final String dataNascimento;
  final String dataCadastro;

  const Funcionario({
    this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.dataCadastro,
  });

  Funcionario copyWith({
    int? id,
    String? nome,
    String? cpf,
    String? dataNascimento,
    String? dataCadastro,
  }) {
    return Funcionario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'cpf': cpf,
      'data_nascimento': dataNascimento,
      'data_cadastro': dataCadastro,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      cpf: (map['cpf'] ?? map['CPF']) as String,
      dataNascimento:
          (map['data_nascimento'] ?? map['dataNascimento']) as String,
      dataCadastro: (map['data_cadastro'] ?? map['dataCadastro']) as String,
    );
  }

  @override
  String toString() =>
      'Funcionario(id: $id, nome: $nome, cpf: $cpf, dataNascimento: $dataNascimento, dataCadastro: $dataCadastro)';
}
