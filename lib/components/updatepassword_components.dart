import 'package:flutter/material.dart';
import 'package:financas/services/api_service.dart';

class UpdatePasswordComponents extends StatefulWidget {
  @override
  _UpdatePasswordComponents createState() => _UpdatePasswordComponents();
}

class _UpdatePasswordComponents extends State<UpdatePasswordComponents> {
  final TextEditingController currentpasswordController =
      TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  PutServices putServices = PutServices();
  bool isLoading = false;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Map<String, String>? validateAndGetPasswords(BuildContext context) {
    final currentpassword = currentpasswordController.text;
    final newpassword = newpasswordController.text;
    final confirmpassword = confirmpasswordController.text;

    if (currentpassword.isEmpty) {
      _showSnackBar(context, 'Senha atual está com o campo vazio!');
      return null;
    }

    if (newpassword.isEmpty || confirmpassword.isEmpty) {
      _showSnackBar(context, 'Por favor, preencha todos os campos de senha!');
      return null;
    }

    if (newpassword != confirmpassword) {
      _showSnackBar(
          context, 'Nova senha e confirmação de senha não coincidem!');
      return null;
    }

    if (currentpassword == newpassword) {
      _showSnackBar(context, 'A nova senha não pode ser igual à senha atual!');
      return null;
    }

    return {
      'currentpassword': currentpassword,
      'newpassword': newpassword,
      'confirmpassword': confirmpassword,
    };
  }

  void updatepassword(BuildContext context) async {
    final passwords = validateAndGetPasswords(context);
    if (passwords == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      final currentpassword = passwords['currentpassword']!;
      final newpassword = passwords['newpassword']!;
      final confirmpassword = passwords['confirmpassword']!;

      bool success = await putServices.updatepassword(
        currentpassword,
        newpassword,
        confirmpassword,
      );

      setState(() {
        isLoading = false;
      });

      if (success) {
        _showSnackBar(context, 'Senha atualizada com sucesso!');
      } else {
        _showSnackBar(context, 'Erro ao atualizar a senha.');
      }
    } catch (error) {
      _showSnackBar(context, 'Erro ao autenticar atualização!');
      print('Erro: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alterar Senha',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066CC),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: currentpasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha Atual',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newpasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmpasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updatepassword(context);
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
