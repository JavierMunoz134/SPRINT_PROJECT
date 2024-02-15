import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'package:firebase_auth/firebase_auth.dart';
import '../data/odoo_connect.dart';
import '../model/User1.dart';
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
            url: '',
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
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          // Asignar el valor de Language usando uno de los valores definidos
          Language userLanguage = Language.enUS; // o Language.esES, según lo que necesites

          // Convertir UID de String a int, si es necesario
          int? userId;
          try {
            userId = int.tryParse(userCredential.user!.uid);
          } catch (e) {
            // Manejar error si el UID no se puede convertir a int
          }

          User1 myAppUser = User1(
            userCredential.user!.email!, // Email
            '', // Password
            true, // Active
            '', // Name
            userLanguage, // Language
            userId, // ID, como entero opcional
            '', // Avatar
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
      } catch (e) {
        yield AuthenticationFailureState(e.toString());
      }
    }



  }
}


