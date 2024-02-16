import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
// Importa tus clases AuthRepository y AuthenticationBloc
 import 'package:sprint/bloc/register_bloc.dart';
 import 'package:sprint/repository/register_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
 const RegisterScreen({super.key});

 @override
 _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 // Controlador para el campo de texto del correo electrónico
 final TextEditingController _emailController = TextEditingController();

 void _showPasswordlessRegisterDialog() {
  showDialog(
   context: context,
   builder: (context) {
    return AlertDialog(
     title: const Text('Registro sin contraseña'),
     content: TextField(
      controller: _emailController,
      decoration: const InputDecoration(
       hintText: 'Introduce tu correo electrónico',
      ),
      keyboardType: TextInputType.emailAddress,
     ),
     actions: <Widget>[
      TextButton(
       child: const Text('Cancelar'),
       onPressed: () {
        Navigator.of(context).pop();
       },
      ),
      TextButton(
       child: const Text('Enviar'),
       onPressed: () {
        // Aquí va la lógica para manejar el envío del correo electrónico
        print('Correo electrónico enviado a: ${_emailController.text}');
        Navigator.of(context).pop();
       },
      ),
     ],
    );
   },
  );
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Registro'),
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
          // Aquí va la lógica de registro
         },
         child: const Text('Registro'),
        ),
       ),
       // Botón para registro sin contraseña
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
         onPressed: _showPasswordlessRegisterDialog,
         child: const Text('Registro sin contraseña'),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }

 @override
 void dispose() {
  // Asegúrate de limpiar el controlador cuando el Widget se deshaga
  _emailController.dispose();
  super.dispose();
 }
}


