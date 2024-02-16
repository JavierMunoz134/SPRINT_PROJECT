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
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
         onPressed: () {
          // Aquí va la lógica de inicio de sesión con Google
         },
         style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50.0),
          ),
         ),
         child: const Text('Google'),
        ),
       ),
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
       TextButton(
        onPressed: () {
         // Mostrar el cuadro de diálogo solo al pulsar "Registro sin contraseña"
         _showEmailInputDialog(context);
        },
        child: Text('Registro sin contraseña'),
       ),
      ],
     ),
    ),
   ),
  );
 }

 // Función para mostrar un AlertDialog pidiendo el correo
 Future<void> _showEmailInputDialog(BuildContext context) async {
  return showDialog(
   context: context,
   builder: (BuildContext context) {
    return AlertDialog(
     title: Text('Introduce tu correo'),
     content: TextFormField(
      decoration: const InputDecoration(
       hintText: 'Correo electrónico',
      ),
     ),
     actions: [
      TextButton(
       onPressed: () {
        Navigator.of(context).pop();
       },
       child: Text('Cancelar'),
      ),
      ElevatedButton(
       onPressed: () {
        // Aquí va la lógica para el registro sin contraseña
        // Puedes obtener el valor del correo ingresado y procesarlo
        Navigator.of(context).pop();
       },
       child: Text('Aceptar'),
      ),
     ],
    );
   },
  );
 }
}
