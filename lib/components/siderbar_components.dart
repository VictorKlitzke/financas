import 'package:financas/dio/api_client.dart';
import 'package:flutter/material.dart';
import 'package:financas/services/api_service.dart';

class SiderBarComponents extends StatefulWidget {
  @override
  _SiderBarComponents createState() => _SiderBarComponents();
}

class _SiderBarComponents extends State<SiderBarComponents> {
  String usuarioName = '';
  String usuarioEmail = '';
  String usuarioAtivo = '';

  final GetServices getServices = GetServices();
  List<Map<String, dynamic>> getUsers = [];

  @override
  void initState() {
    super.initState();
    getUsuarios();
  }

  void getUsuarios() async {
    String nome = '';
    String email = '';
    String ativo = '';
    try {
      final result = await getServices.getuser();

      if (result.isNotEmpty) {
        nome = result[0]['nome'] ?? 'Desconhecido';
        email = result[0]['email'] ?? 'Desconhecido';
        if (result[0]['ativo'] == 1) {
          ativo = 'Usuário Ativo';
        }
      }
      ;

      usuarioName = nome;
      usuarioEmail = email;
      usuarioAtivo = ativo;

      setState(() {
        getUsers = result;
      });
    } catch (error) {
      print('Erro ao buscar usuários: $error');
    }
  }

  void logout(BuildContext context) async {
    try {
      final response = await dio.post('logout');

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao tentar sair do aplicativo'),
          ),
        );
      }
    } catch (error) {
      print('Erro ao fazer logout: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao tentar sair do aplicativo'),
        ),
      );
    }
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  usuarioName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  usuarioEmail,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  usuarioAtivo,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Criar Orçamento'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/budget');
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categorias'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/category');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: const Text('Contas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/accounts');
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.list),
                title: const Text('Despesas'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Registrar Transação'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/expense');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.expand),
                    title: const Text('Lista Despesas'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/listtransacao');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Sair'),
          onTap: () {
            Navigator.pop(context);
            logout(context);
          },
        ),
      ],
    );
  }
}
