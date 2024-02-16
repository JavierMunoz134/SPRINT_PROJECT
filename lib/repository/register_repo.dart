import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> sendPasswordlessSignInLink(String email) async {
    var acs = ActionCodeSettings(
      url: 'https://tuproject.firebaseapp.com/finishSignUp?cartId=1234',//Especifica la URL a la que se redirigirá al usuario después de hacer clic en el enlace de inicio de sesión que recibió por correo electrónico. Esta URL debe estar asociada con la página donde completarás el proceso de inicio de sesión en tu aplicación web.
      handleCodeInApp: true,
      androidPackageName: 'com.tuempresa.tuapp',
      androidInstallApp: true,
      androidMinimumVersion: '12',

    );

    try {
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: acs,
      );
      // Si esta línea se ejecuta, el correo electrónico ha sido enviado exitosamente.
      print('Correo electrónico enviado exitosamente.');
    } catch (e) {
      // Manejo del error, puedes imprimir el error o manejarlo como consideres necesario.
      print('Error al enviar el correo electrónico: $e');
      throw e; // Opcionalmente, puedes lanzar el error para manejarlo en otra parte.
    }
  }
}
