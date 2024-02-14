import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'package:firebase_auth/firebase_auth.dart';
import '../data/odoo_connect.dart';
import '../model/language.dart';


// Eventos relacionados con la autenticación
abstract class AuthEvent {}

class SignUpUser extends AuthEvent {
  final String email;

  SignUpUser(this.email);
}

class VerifyCode extends AuthEvent {
  final String verificationCode;

  VerifyCode(this.verificationCode);
}

// Estados de autenticación
abstract class AuthState {}

class AuthenticationLoadingState extends AuthState {}

class AuthenticationSuccessState extends AuthState {
  final User user;

  AuthenticationSuccessState(this.user);
}

class AuthenticationFailureState extends AuthState {
  final String errorMessage;

  AuthenticationFailureState(this.errorMessage);
}

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationBloc() : super(AuthenticationLoadingState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUpUser) {
      yield AuthenticationLoadingState();
      try {
        // Enviar correo electrónico de verificación
        await _auth.sendSignInLinkToEmail(
          email: event.email,
          actionCodeSettings: ActionCodeSettings(
            url: 'https://your-app-url.com',
            handleCodeInApp: true,
          ),
        );
        yield AuthenticationSuccessState(_auth.currentUser!);
      } catch (e) {
        yield AuthenticationFailureState(e.toString());
      }
    } else if (event is VerifyCode) {
      yield AuthenticationLoadingState();
      try {
        final AuthCredential credential = EmailAuthProvider.credentialWithLink(
          email: _auth.currentUser!.email!,
          emailLink: event.verificationCode,
        );
        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

        // Verificamos que el usuario no sea nulo antes de llamar a createUser
        if (userCredential.user != null) {
          // Crear una instancia de tu clase User usando la información del User de Firebase
          User myAppUser = User(
            userCredential.user!.email!, // asegúrate de que el email no sea nulo
            '', // password - puede ser cualquier valor, ya que no se usa
            true, // active
            '', // name - puede ser cualquier valor, ya que no se usa
            //Language.english, // lang
            userCredential.user!.uid, // id
            '', // avatar - puede ser cualquier valor, ya que no se usa
          );

          final bool isCreated = await OdooConnect.createUser(myAppUser);
          if (isCreated) {
            yield AuthenticationSuccessState(userCredential.user!);
          } else {
            yield AuthenticationFailureState('Error al registrar usuario en Odoo');
          }
        } else {
          yield AuthenticationFailureState('Error al obtener datos del usuario');
        }

        // Añadimos la línea para asignar firebase.User a firebaseUser
        firebase.User firebaseUser = userCredential.user!;
      } catch (e) {
        yield AuthenticationFailureState(e.toString());
      }
    }
  }
}


