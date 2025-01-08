import 'package:flutter/material.dart';
import 'package:financas/pages/accounts_page.dart';
import 'package:financas/pages/category_page.dart';
import 'package:financas/pages/createbudget_page.dart';
import 'package:financas/pages/expenses_page.dart';
import 'package:financas/pages/listTransacao_page.dart';
import 'package:financas/pages/login_page.dart';
import 'package:financas/pages/dashboard_page.dart';
import 'package:financas/dio/api_client.dart';
import 'package:financas/pages/profile_page.dart';
import 'package:financas/pages/register_page.dart';
import 'package:financas/layout/base_layout.dart';
import 'package:financas/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klitzke',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
        '/budget': (context) => BaseLayout(body: CreatebudgetPage()),
        '/listtransacao': (context) => BaseLayout(
              body: ListTransacao(),
            ),
        '/settings': (context) => BaseLayout(body: SettingsPage()),
        '/profile': (context) => BaseLayout(body: ProfilePage()),
        '/category': (context) => BaseLayout(
              body: CategoryRegisterPage(),
            ),
        '/expense': (context) => BaseLayout(
              body: ExpensesPage(),
            ),
        '/accounts': (context) => BaseLayout(
              body: AccountsRegisterPage(),
            ),
      },
    );
  }
}
