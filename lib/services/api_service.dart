import 'package:financas/dio/api_client.dart';

class PostServices {
  Future<bool> registerAccounts(String account, String balance) async {
    try {
      final response = await dio.post('/registerAccounts',
          data: {'account': account, 'balance': balance});

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> registerExpense(data) async {
    try {
      final response =
          await dio.post('registerExpense', data: {'expense': data});
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> registerCategory(String category, String type) async {
    try {
      final response = await dio
          .post('registerCategory', data: {'category': category, 'type': type});

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
}

class GetServices {
  Future<List<Map<String, dynamic>>> getuser() async {
    try {
      final response = await dio.get('getuser');

      if (response.data != null && response.data['getuser'] != null) {
        return List<Map<String, dynamic>>.from(response.data['getuser']);
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCategorys() async {
    try {
      final response = await dio.get('getCategorys');

      if (response.data != null && response.data['getCategorys'] != null) {
        return List<Map<String, dynamic>>.from(response.data['getCategorys']);
      } else {
        return [];
      }
    } catch (error) {
      print('Erro ao buscar lista de categorias $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    try {
      final response = await dio.get('getAccounts');

      if (response.data != null && response.data['getAccounts'] != null) {
        return List<Map<String, dynamic>>.from(response.data['getAccounts']);
      } else {
        return [];
      }
    } catch (error) {
      print('Erro ao buscar lista de constas $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTransition() async {
    try {
      final response = await dio.get('getTransition');

      if (response.data != null && response.data['getTransition'] != null) {
        return List<Map<String, dynamic>>.from(response.data['getTransition']);
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}

class PutServices {
  Future<bool> updatepassword(String currentpassword, String newpassword,
      String confirmpassword) async {
    try {
      final response = await dio.put('updatepassword', data: {
        'currentpassword': currentpassword,
        'newpassword': newpassword,
        'confirmpassword': confirmpassword,
      });

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Usuário não autenticado.');
      } else {
        throw Exception(
            'Erro ao atualizar a senha. Código: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao atualizar senha: $error');
      return false;
    }
  }

  Future<bool> verifyEmailCode(
      String currentEmail, String newEmail, String code) async {
    try {
      final response = await dio.put('verifyEmailCode', data: {
        'currentemail': currentEmail,
        'newemail': newEmail,
        'code': code,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateemail(String currentEmail, String newEmail) async {
    try {
      final response = await dio.put('updateemail',
          data: {'currentemail': currentEmail, 'newemail': newEmail});

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Usuário não autenticado.');
      } else {
        throw Exception(
            'Erro ao atualizar a senha. Código: ${response.statusCode}');
      }
    } catch (error) {
      print('errore: $error');
      return false;
    }
  }
}

class DeleteServices {
  Future<bool> deleteAccounts(int index) async {
    try {
      final response = await dio.delete('deleteAccounts', data: {'index': index});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
  Future<bool> deleteCategory(int index) async {
    try {
      final response =
          await dio.delete('deletecategory', data: {'index': index});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteTransacao(int index) async {
    try {
      final response =
          await dio.delete('deletetransacao', data: {'index': index});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
