import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:financas/layout/base_layout.dart';
import 'package:financas/services/api_service.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  @override
  _FinancialDashboardPageState createState() => _FinancialDashboardPageState();
}

class _FinancialDashboardPageState extends State<DashboardPage> {
  final GetServices getServices = GetServices();

  List<Map<String, dynamic>> getTransitions = [];
  List<Map<String, dynamic>> transacoesRecentes = [];

  double saldoAtual = 0.0;
  double totalReceitas = 0.0;
  double totalDespesas = 0.0;

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  @override
  void initState() {
    super.initState();
    fetchRecentes();
    fetchTransactions();
  }

  void fetchRecentes() async {
    try {
      final result = await getServices.getTransition();
      setState(() {
        transacoesRecentes = result
            .map((item) => {
                  'Descrição': item['descricao'] ?? 'Sem descrição',
                  'Data': item['data_transacao'] ?? 'Data desconhecida',
                  'Valor':item['valor'] ?? 0.0,
                })
            .take(4)
            .toList();

        print('Resultados das transações: $result');
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao tentar buscar transações recentes!'),
        ),
      );
       print('Erro ao tentar: $error');
    }
  }

  void fetchTransactions() async {
    try {
      final result = await getServices.getTransition();

      double saldoTemp = 0.0;
      double receitasTemp = 0.0;
      double despesasTemp = 0.0;

      setState(() {
        getTransitions = result
            .map((item) => {
                  'id': item['id'] ?? 0,
                  'Descrição': item['descricao'] ?? 'Sem descrição',
                  'Data': item['data_transacao'] ?? 'Data desconhecida',
                  'valor': item['valor'] ?? 0.0,
                  'tipo': item['tipo'] ?? 'Entrada',
                })
            .toList();

        for (var item in result) {
          double valor = 0.0;

          if (item['valor'] is String) {
            String valorString = item['valor'];
            String valorFormatado =
                valorString.replaceAll(RegExp(r'\.(?=\d{3}(,|\b))'), '');
            valorFormatado = valorFormatado.replaceFirst(',', '.');
            valor = double.tryParse(valorFormatado) ?? 0.0;
          }

          print(
              'Descrição: ${item['descricao']}, Valor: $valor, Tipo: ${item['tipo']}');

          if (item['tipo'] == 'Entrada') {
            receitasTemp += valor;
          } else if (item['tipo'] == 'Saída') {
            despesasTemp += valor;
          }
        }

        saldoTemp = receitasTemp - despesasTemp;

        saldoAtual = saldoTemp;
        totalReceitas = receitasTemp;
        totalDespesas = despesasTemp;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao tentar buscar informações para o dashboard!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildCards(),
              const SizedBox(height: 30),
              _buildChartSection(),
              const SizedBox(height: 30),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Resumo Financeiro',
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCard('Saldo Atual', saldoAtual, Colors.teal),
          _buildCard('Receitas', totalReceitas, Colors.green),
          _buildCard('Despesas', totalDespesas, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildCard(String title, double value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(value),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Receitas vs Despesas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: totalReceitas > totalDespesas
                      ? totalReceitas
                      : totalDespesas,
                  barGroups: [
                    _buildBarChartGroupData(0, totalReceitas, Colors.green),
                    _buildBarChartGroupData(1, totalDespesas, Colors.redAccent),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Receitas');
                            case 1:
                              return const Text('Despesas');
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarChartGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transações Recentes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: transacoesRecentes.map((transacao) {
            final descricao = transacao["Descrição"] ?? 'Sem descrição';
            final data = transacao["Data"] ?? 'Data desconhecida';
            final valor = transacao["Valor"] ?? 'R\$ 0.00';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  descricao,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Data: $data'),
                trailing: Text(
                  valor,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
