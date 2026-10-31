import 'package:meu_projeto/meu_projeto.dart';

void main() {
  final cliente = Cliente(
    id: 1,
    nome: 'Carlos Silva',
    cpf: '123.456.789-00',
    dataNascimento: '1985-04-12',
    dataCadastro: '2023-01-10',
  );
  print(cliente);

  final funcionario = Funcionario(
    id: 1,
    nome: 'Mariana Souza',
    cpf: '987.654.321-11',
    dataNascimento: '1992-08-25',
    dataCadastro: '2022-03-15',
  );
  print(funcionario);

  final veiculo = Veiculo(
    id: 1,
    clienteId: cliente.id,
    cliente: cliente,
    modelo: 'Civic',
    marca: 'Honda',
    ano: 2020,
    placa: 'ABC-1D23',
  );
  print(veiculo);

  final veiculoAtualizado = veiculo.copyWith(modelo: 'Civic Touring');
  print(veiculoAtualizado);

  final servicoTrocaOleo = Servico(
    id: 1,
    descricao: 'Troca de Óleo e Filtro',
    valor: 200.00,
  );
  final servicoAlinhamento = Servico(
    id: 2,
    descricao: 'Alinhamento e Balanceamento',
    valor: 150.00,
  );

  servicoTrocaOleo.reajustarValor(10.0);
  print(servicoTrocaOleo);

  final statusAberto = const Status(id: 1, descricao: 'Aberto');
  final statusConcluido = const Status(id: 2, descricao: 'Concluído');

  final os = OrdemServico(
    id: 101,
    funcionario: funcionario,
    veiculo: veiculo,
    status: statusAberto,
    dataEntrada: '2026-10-30 08:30:00',
  );
  print(os);

  try {
    os.concluir(statusConcluido);
  } catch (e) {
    print('Validação de conclusão sem trabalhos: $e');
  }

  final item1 = OrdemServicoServico.fromServico(servicoTrocaOleo);
  final item2 = OrdemServicoServico.fromServico(servicoAlinhamento);

  os.adicionarServico(item1);
  os.adicionarServico(item2);

  print('Total da OS: R\$ ${os.calcularTotal().toStringAsFixed(2)}');

  os.concluir(statusConcluido);
  print('OS Concluída: $os');

  final osMap = os.toMap();
  final osReconstruida = OrdemServico.fromMap(osMap);
  print('OS Reconstruída: $osReconstruida');
}
