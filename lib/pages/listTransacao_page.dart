import 'package:flutter/material.dart';
import 'package:financas/services/api_service.dart';
import 'package:financas/utils/dialog_utils.dart';

class ListTransacao extends StatefulWidget {

  @override
  _ListTransacao createState() => _ListTransacao();
}

class _ListTransacao extends State<ListTransacao> {
  final GetServices getServices = GetServices();
  final DeleteServices deleteServices = DeleteServices();

  List<Map<String, dynamic>> transacoes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTransacoes();
  }

  void fetchTransacoes() async {
    try {
      final result = await getServices.getTransition();
      setState(() {
        transacoes = result;
      });
      print(result);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar transações')),
      );
      print('Erro ao carregar transações $error');
    }
  }

  void confirmDeleteTransacao(int index) async {
    bool? shouldDelete = await DialogUtils.showConfirmationDialog(
        context: context,
        title: 'Confirmação',
        content: 'Tem certeza que deseja deletar esta transação?');

    if (shouldDelete == true) {
      deleteTransacao(index);
    }
  }

  void deleteTransacao(int index) async {
    setState(() {
      isLoading = true;
    });

    try {
      bool success = await deleteServices.deleteTransacao(index);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação deletada com sucesso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao deletar a transação')),
        );
      }
    } catch (error) {
      print('Erro ao deletar transação: $error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Transações Registradas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : transacoes.isEmpty
                      ? const Center(
                          child: Text('Nenhuma transação registrada ainda'),
                        )
                      : ListView.builder(
                          itemCount: transacoes.length,
                          itemBuilder: (context, index) {
                            final transacao = transacoes[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Icon(
                                  transacao['tipo'] == 'Entrada'
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: transacao['tipo'] == 'Entrada'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(
                                  transacao['descricao'] ?? 'Sem descrição',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Tipo: ${transacao['tipo']} | Valor: R\$ ${transacao['valor']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      confirmDeleteTransacao(transacao['id']),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
