import 'package:flutter/material.dart';
import 'package:financas/services/api_service.dart';

class UpdateEmailComponents extends StatefulWidget {
  @override
  _UpdateEmailComponentsState createState() => _UpdateEmailComponentsState();
}

class _UpdateEmailComponentsState extends State<UpdateEmailComponents> {
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();

  final PutServices putServices = PutServices();

  bool isLoading = false;
  bool showVerificationField = false;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Map<String, String>? validateEmail(BuildContext context) {
    final String currentEmail = currentEmailController.text.trim();
    final String newEmail = newEmailController.text.trim();

    if (currentEmail.isEmpty) {
      _showSnackBar(context, 'Email atual está com o campo vazio!');
      return null;
    }
    if (newEmail.isEmpty) {
      _showSnackBar(context, 'Novo email está com o campo vazio!');
      return null;
    }
    if (currentEmail == newEmail) {
      _showSnackBar(context, 'Email atual é igual ao email novo!');
      return null;
    }

    return {
      'currentEmail': currentEmail,
      'newEmail': newEmail,
    };
  }

  void handleSave() async {
    final emails = validateEmail(context);

    if (emails == null) return;

    setState(() {
      isLoading = true;
    });

    final String currentEmail = emails['currentEmail']!;
    final String newEmail = emails['newEmail']!;

    bool success = await putServices.updateemail(currentEmail, newEmail);

    setState(() {
      isLoading = false;
    });

    if (success) {
      setState(() {
        showVerificationField = true;
      });
      _showSnackBar(
          context, 'Código de verificação enviado para o novo e-mail.');
    } else {
      _showSnackBar(context, 'Erro ao enviar código de verificação.');
    }
  }

  void verifyCode() async {
    final String code = verificationCodeController.text.trim();
    final emails = validateEmail(context);

    if (emails == null) return;

    if (code.isEmpty) {
      _showSnackBar(context, 'O campo de código está vazio!');
      return;
    }

    final String currentEmail = emails['currentEmail']!;
    final String newEmail = emails['newEmail']!;

    setState(() {
      isLoading = true;
    });

    bool success =
        await putServices.verifyEmailCode(currentEmail, newEmail, code);

    setState(() {
      isLoading = false;
    });

    if (success) {
      _showSnackBar(context, 'E-mail verificado com sucesso!');
      Navigator.of(context).pop();
    } else {
      _showSnackBar(context, 'Código inválido ou expirado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Atualizar E-mail',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0066CC),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: currentEmailController,
              decoration: const InputDecoration(
                labelText: 'E-mail Atual',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newEmailController,
              decoration: const InputDecoration(
                labelText: 'Novo E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            if (showVerificationField) ...[
              const SizedBox(height: 16),
              TextField(
                controller: verificationCodeController,
                decoration: const InputDecoration(
                  labelText: 'Código de Verificação',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: showVerificationField ? verifyCode : handleSave,
          child: Text(showVerificationField ? 'Verificar Código' : 'Salvar'),
        ),
      ],
    );
  }
}
