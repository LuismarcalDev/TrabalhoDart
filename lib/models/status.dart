class Status {
  final int? id;
  final String descricao;

  const Status({
    this.id,
    required this.descricao,
  });

  Status copyWith({
    int? id,
    String? descricao,
  }) {
    return Status(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'descricao': descricao,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'] as int?,
      descricao: map['descricao'] as String,
    );
  }

  @override
  String toString() => 'Status(id: $id, descricao: $descricao)';
}
