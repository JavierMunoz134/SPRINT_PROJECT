import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
// Importa tus clases AuthRepository y AuthenticationBloc
 import 'package:sprint/bloc/register_bloc.dart';
 import 'package:sprint/repository/register_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Campo de texto para el correo electrónico
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Introduce tu correo electrónico',
                  labelText: 'Correo electrónico',
                ),
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Introduce tu contraseña',
                  labelText: 'Contraseña',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí va la lógica de registro normal
                  },
                  child: const Text('Registro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _sendVerificationEmail(context);
                  },
                  child: const Text('Registrar sin contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendVerificationEmail(BuildContext context) async {
    final authRepository = RepositoryProvider.of<AuthRepository>(context);
    try {
      await authRepository.registerUser(_emailController.text);
      _showVerificationCodeDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showVerificationCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Introduce el código de verificación"),
          content: TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              hintText: 'Código de verificación',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Verificar'),
              onPressed: () {
                _verifyCode(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _verifyCode(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    try {
      authenticationBloc.add(VerifyCode(_codeController.text));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al verificar el código: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

}


