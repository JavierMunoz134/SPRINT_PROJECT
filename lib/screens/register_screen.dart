import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Introduce tu nombre de usuario',
                  labelText: 'Nombre de usuario',
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
                    // Aquí abrimos el pop-up para registro sin contraseña
                    _showVerificationCodeDialog(context);
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

  void _showVerificationCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Introduce el código de verificación"),
          content: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Código de verificación',
            ),
            // Aquí puedes añadir el controlador para manejar el texto ingresado
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
                // Aquí va la lógica para manejar la verificación
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
