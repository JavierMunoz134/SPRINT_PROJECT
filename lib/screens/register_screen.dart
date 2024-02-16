import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
// Importa tus clases AuthRepository y AuthenticationBloc
import 'package:sprint/bloc/register_bloc.dart';
import 'package:sprint/repository/register_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprint/data/odoo_connect.dart';
import '../model/language.dart';
import '../model/user.dart';
import 'package:sprint/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
 const RegisterScreen({super.key});

 @override
 _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 final TextEditingController _emailController = TextEditingController();

 void _popRegistroOdoo() {
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
        // Llama al BLoC para enviar el correo electrónico
        context.read<RegisterBloc>().add(SendPasswordlessEmail(_emailController.text));

        _showPasswordlessRegisterDialog();


       },
      ),
     ],
    );
   },
  );
 }


 void _showPasswordlessRegisterDialog() {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  showDialog(
   context: context,
   builder: (context) {
    return AlertDialog(
     title: const Text('Registro sin contraseña'),
     content: SingleChildScrollView(
      child: ListBody(
       children: <Widget>[
        TextField(
         controller: _emailController,
         decoration: const InputDecoration(
          hintText: 'Introduce tu correo electrónico',
         ),
         keyboardType: TextInputType.emailAddress,
        ),
        TextField(
         controller: _usernameController,
         decoration: const InputDecoration(
          hintText: 'Introduce tu nombre de usuario',
         ),
        ),
        TextField(
         controller: _passwordController,
         decoration: const InputDecoration(
          hintText: 'Introduce tu contraseña',
         ),
         obscureText: true,
        ),
        // Agrega aquí más campos si son necesarios
       ],
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
       child: const Text('Enviar'),
       onPressed: () async {
        // Recolectar datos del formulario
        final String email = _emailController.text;
        final String username = _usernameController.text;
        final String password = _passwordController.text;
        // Asume que el usuario está activo y elige un idioma por defecto
        final bool active = true;
        final Language lang = Language.enUS;


        // Crear instancia de User
        final user = User(email, password, active, username, lang);

        // Llamar a createUser y manejar la respuesta
        final bool success = await OdooConnect.createUser(user);
        Navigator.of(context).pop(); // Cierra el diálogo

        if (success) {
         // Mostrar un mensaje de éxito
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario creado exitosamente')),
         );

         // Navegar a HomeScreen después de un corto retraso
         Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => HomeScreen()),
          );
         });
        } else {
         // Mostrar un mensaje de error
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el usuario')),
         );
        }

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
         onPressed: _popRegistroOdoo,
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


