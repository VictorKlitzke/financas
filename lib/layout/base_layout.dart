import 'package:flutter/material.dart';
import 'package:financas/components/footer_components.dart';
import 'package:financas/components/siderbar_components.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;

  const BaseLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Financeiro'),
        backgroundColor: const Color(0xFF0066CC),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(child: SiderBarComponents()),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF3F7FB),
      resizeToAvoidBottomInset: true, 
      body: Column(
        children: [
          Expanded(child: body),
          FooterComponents(),
        ],
      ),
    );
  }
}
