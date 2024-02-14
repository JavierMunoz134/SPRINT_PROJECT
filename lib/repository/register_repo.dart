import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para registrar usuarios
  Future<void> registerUser(String email) async {
    try {
      // Enviar correo electrónico de verificación
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://your-app-url.com', // URL profunda para redirigir después de la verificación
          handleCodeInApp: true, // Abre la aplicación automáticamente al hacer clic en el enlace
        ),
      );
    } catch (e) {
      throw Exception('Error al enviar el correo de verificación: $e');
    }
  }

  // Método para verificar el código de verificación
  Future<void> verifyCode(String verificationCode) async {
    try {
      final AuthCredential credential = EmailAuthProvider.credentialWithLink(
        email: _auth.currentUser!.email!,
        emailLink: verificationCode,  // Cambio realizado aquí
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Error al verificar el código: $e');
    }
  }

}