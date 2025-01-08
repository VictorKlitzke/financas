import 'package:flutter/material.dart';
import 'package:financas/components/updateemail_components.dart';
import 'package:financas/components/updatepassword_components.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferências',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              title: const Text(
                'Alterar Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              leading: const Icon(Icons.email, color: Color(0xFF0066CC)),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => UpdateEmailComponents());
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              title: const Text(
                'Alterar Senha',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              leading: const Icon(Icons.lock, color: Color(0xFF0066CC)),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => UpdatePasswordComponents());
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              title: const Text(
                'Idioma',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              leading: const Icon(Icons.language, color: Color(0xFF0066CC)),
              onTap: () {
                // Ação para alterar idioma
              },
            ),
          ],
        ),
      ),
    );
  }
}
