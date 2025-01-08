import 'package:financas/dio/api_client.dart';

class AuthService {
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await dio.post('register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Erro ao fazer autenticação: $error');
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post('login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Erro ao fazer login: $error');
      return false;
    }
  }
}
