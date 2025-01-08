import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:financas/services/api_service.dart';

import 'package:intl/intl.dart';

class MoneyInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) return newValue;

    final number = int.tryParse(text);
    if (number == null) return newValue;

    final formatted = formatter.format(number / 100);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final GetServices getServices = GetServices();
  final PostServices postServices = PostServices();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  List<Map<String, dynamic>> getAccounts = [];
  List<Map<String, dynamic>> getCategorys = [];

  bool isLoading = false;

  String? selectedAccount;
  String? selectedCategory;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    fetchAccounts();
    fetchCategories();
  }

  void fetchAccounts() async {
    try {
      final result = await getServices.getAccounts();
      setState(() {
        getAccounts = result
            .map((item) => {
                  'id': item['id'] ?? '0',
                  'nome': item['nome'] ?? 'Conta Desconhecida',
                })
            .toList();

        if (getAccounts.isNotEmpty) {
          if (selectedAccount == null ||
              getAccounts.every((item) => item['id'] != selectedAccount)) {
            selectedAccount = getAccounts.first['id'].toString();
          }
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar contas')),
      );
      print('Erro ao carregar as contas $error');
    }
  }

  void fetchCategories() async {
    try {
      final result = await getServices.getCategorys();

      setState(() {
        getCategorys = result
            .map((item) => {
                  'id': item['id'] ?? '0',
                  'nome': item['nome'] ?? 'Categoria Desconhecida'
                })
            .toList();

        if (getCategorys.isNotEmpty && selectedCategory == null) {
          selectedCategory = getCategorys.first['id'].toString();
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar categorias')),
      );
      print('Erro ao fazer consulta de categorias $error');
    }
  }

  void registerExpense(BuildContext context) async {
    final data = {
      "conta_id": selectedAccount,
      "categoria_id": selectedCategory,
      "valor": valorController.text
          .trim()
          .replaceAll(',', '.')
          .replaceAll('R\$', ''),
      "tipo": selectedType,
      "descricao": descricaoController.text,
      "data_transacao": dataController.text,
    };

    print("Dados da Transação: $data");

    if (data['descricao']!.isEmpty ||
        data['data_transacao']!.isEmpty ||
        data['tipo']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha os campos!'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await postServices.registerExpense(data);

    await Future.delayed(const Duration(seconds: 2));

    print(success);

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação registrada com sucesso!')),
      );
      valorController.clear();
      descricaoController.clear();
      dataController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao registrar transação')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              buildMoneyField('Valor', valorController),
              const SizedBox(height: 16),
              Text(
                'Conta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              buildDropdownField(
                'Conta',
                getAccounts,
                selectedAccount,
                (value) {
                  setState(() {
                    selectedAccount = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Categoria',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              buildDropdownField(
                'Categoria',
                getCategorys,
                selectedCategory,
                (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Tipo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: 'Entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'Saída', child: Text('Saída')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              buildTextField(
                  'Descrição', descricaoController, TextInputType.text),
              const SizedBox(height: 16),
              Text(
                'Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              buildDateField('Data (YYYY-MM-DD)', dataController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => registerExpense(context),
                  child: const Text('Cadastrar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoneyField(
    String label,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [MoneyInputFormatter()],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildDateField(
    String label,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
        ),
        border: const OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildDropdownField(
    String label,
    List<Map<String, dynamic>> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    final validItems =
        items.where((item) => item['id'] != null && item['id'] != '0').toList();

    final validSelectedValue =
        validItems.any((item) => item['id'].toString() == selectedValue)
            ? selectedValue
            : null;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        border: const OutlineInputBorder(),
      ),
      value: validSelectedValue,
      items: validItems.map((item) {
        return DropdownMenuItem<String>(
          value: item['id'].toString(),
          child: Text(item['nome'] ?? 'Sem Nome'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
