import 'package:meu_projeto/meu_projeto.dart';
import 'package:test/test.dart';

void main() {
  group('Cliente', () {
    test('criação, copyWith, toMap e fromMap', () {
      final c1 = Cliente(
        id: 1,
        nome: 'João da Silva',
        cpf: '111.222.333-44',
        dataNascimento: '1990-01-01',
        dataCadastro: '2023-01-01',
      );

      expect(c1.id, equals(1));
      expect(c1.nome, equals('João da Silva'));

      final c2 = c1.copyWith(nome: 'João Souza');
      expect(c2.id, equals(1));
      expect(c2.nome, equals('João Souza'));
      expect(c2.cpf, equals(c1.cpf));

      final map = c1.toMap();
      expect(map['nome'], equals('João da Silva'));
      expect(map['cpf'], equals('111.222.333-44'));

      final cReconst = Cliente.fromMap(map);
      expect(cReconst.nome, equals(c1.nome));
      expect(cReconst.cpf, equals(c1.cpf));
      expect(cReconst.toString(), contains('João da Silva'));
    });
  });

  group('Funcionario', () {
    test('criação, copyWith, toMap e fromMap', () {
      final f1 = Funcionario(
        id: 10,
        nome: 'Maria Gerente',
        cpf: '555.666.777-88',
        dataNascimento: '1988-05-15',
        dataCadastro: '2022-06-10',
      );

      final map = f1.toMap();
      final f2 = Funcionario.fromMap(map);
      expect(f2.id, equals(10));
      expect(f2.nome, equals('Maria Gerente'));

      final fCopia = f1.copyWith(nome: 'Maria Silva');
      expect(fCopia.nome, equals('Maria Silva'));
      expect(fCopia.cpf, equals(f1.cpf));
    });
  });

  group('Veiculo', () {
    test('imutabilidade da placa e relacionamentos', () {
      final c = Cliente(
        id: 1,
        nome: 'Lucas',
        cpf: '000.111.222-33',
        dataNascimento: '1995-10-10',
        dataCadastro: '2023-05-05',
      );

      final v = Veiculo(
        id: 5,
        cliente: c,
        modelo: 'Corolla',
        marca: 'Toyota',
        ano: 2022,
        placa: 'XYZ-9876',
      );

      expect(v.placa, equals('XYZ-9876'));
      expect(v.cliente?.nome, equals('Lucas'));

      final vAtualizado = v.copyWith(modelo: 'Corolla Cross');
      expect(vAtualizado.modelo, equals('Corolla Cross'));
      expect(vAtualizado.placa, equals('XYZ-9876'));

      final map = v.toMap();
      expect(map['placa'], equals('XYZ-9876'));
      expect(map['cliente'], isNotNull);

      final vFromMap = Veiculo.fromMap(map);
      expect(vFromMap.placa, equals('XYZ-9876'));
      expect(vFromMap.cliente?.nome, equals('Lucas'));
    });
  });

  group('Servico', () {
    test('reajuste de valor e validação de negativo', () {
      final s = Servico(
        id: 1,
        descricao: 'Troca de Correia',
        valor: 100.0,
      );

      expect(s.valor, equals(100.0));

      s.reajustarValor(15.0);
      expect(s.valor, equals(115.0));

      s.valor = 120.0;
      expect(s.valor, equals(120.0));

      expect(() => s.valor = -10.0, throwsArgumentError);
      expect(() => Servico(descricao: 'Inválido', valor: -5), throwsArgumentError);
    });
  });

  group('OrdemServico', () {
    late Funcionario func;
    late Veiculo veic;
    late Servico serv1;
    late Servico serv2;

    setUp(() {
      func = Funcionario(
        id: 1,
        nome: 'Carlos',
        cpf: '123.456.789-00',
        dataNascimento: '1990-01-01',
        dataCadastro: '2021-01-01',
      );

      veic = Veiculo(
        id: 1,
        modelo: 'Gol',
        marca: 'VW',
        ano: 2018,
        placa: 'BRA2E19',
      );

      serv1 = Servico(id: 1, descricao: 'Troca de pastilha', valor: 150.0);
      serv2 = Servico(id: 2, descricao: 'Revisão geral', valor: 350.0);
    });

    test('imutabilidade da data de abertura (dataEntrada)', () {
      final os = OrdemServico(
        id: 1,
        dataEntrada: '2026-10-30 10:00:00',
        funcionario: func,
        veiculo: veic,
      );

      expect(os.dataEntrada, equals('2026-10-30 10:00:00'));

      final osCopia = os.copyWith(id: 2);
      expect(osCopia.dataEntrada, equals('2026-10-30 10:00:00'));
    });

    test('regra: atendimento não pode ser concluído sem trabalhos', () {
      final os = OrdemServico(
        id: 1,
        dataEntrada: '2026-10-30 10:00:00',
        funcionario: func,
        veiculo: veic,
      );

      expect(os.servicos.isEmpty, isTrue);

      expect(() => os.concluir(), throwsStateError);

      expect(
        () => os.alterarStatus(const Status(descricao: 'Concluído')),
        throwsStateError,
      );

      expect(
        () => os.copyWith(status: const Status(descricao: 'Concluído')),
        throwsStateError,
      );
    });

    test('cálculo do total e conclusão com serviços associados', () {
      final os = OrdemServico(
        id: 1,
        dataEntrada: '2026-10-30 10:00:00',
        funcionario: func,
        veiculo: veic,
        status: const Status(descricao: 'Aberto'),
      );

      os.adicionarServico(OrdemServicoServico.fromServico(serv1));
      os.adicionarServico(OrdemServicoServico.fromServico(serv2));

      expect(os.servicos.length, equals(2));
      expect(os.calcularTotal(), equals(500.0));
      expect(os.total, equals(500.0));

      os.concluir();
      expect(os.status?.descricao, equals('Concluído'));
    });

    test('serialização toMap() e reconstrução fromMap() completas', () {
      final os = OrdemServico(
        id: 10,
        dataEntrada: '2026-10-30 10:00:00',
        funcionario: func,
        veiculo: veic,
        status: const Status(id: 1, descricao: 'Em Andamento'),
        servicos: [
          OrdemServicoServico.fromServico(serv1),
          OrdemServicoServico.fromServico(serv2),
        ],
      );

      final map = os.toMap();
      expect(map['data_entrada'], equals('2026-10-30 10:00:00'));
      expect(map['servicos'], isList);
      expect((map['servicos'] as List).length, equals(2));

      final osReconstruida = OrdemServico.fromMap(map);
      expect(osReconstruida.id, equals(10));
      expect(osReconstruida.dataEntrada, equals('2026-10-30 10:00:00'));
      expect(osReconstruida.funcionario?.nome, equals('Carlos'));
      expect(osReconstruida.veiculo?.placa, equals('BRA2E19'));
      expect(osReconstruida.status?.descricao, equals('Em Andamento'));
      expect(osReconstruida.servicos.length, equals(2));
      expect(osReconstruida.calcularTotal(), equals(500.0));
    });
  });
}
