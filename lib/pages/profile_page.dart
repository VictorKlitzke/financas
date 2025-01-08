import 'package:flutter/material.dart';
import 'package:financas/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  GetServices getservices = GetServices();

  String nameUser = '';
  String emailUser = '';

  List<Map<String, dynamic>> getusers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    String nameUsers = '';
    String emailUsers = '';

    try {
      final result = await getservices.getuser();

      if (result.isNotEmpty) {
        nameUsers = result[0]['nome'] ?? 'Desconhecido';
        emailUsers = result[0]['email'] ?? 'Desconhecido';
      }

      nameUser = nameUsers;
      emailUser = emailUsers;

      setState(() {
        getusers = result;
      });
    } catch (error) {
      print('Erro ao buscar usuários: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perfil do Usuário',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 20),
            InfoTile(
              title: 'Nome:',
              value: nameUser,
            ),
            const SizedBox(height: 10),
            InfoTile(
              title: 'E-mail:',
              value: emailUser,
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[400]),
            const SizedBox(height: 10),
            const Text(
              'Configurações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Desativar conta'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const InfoTile({
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
