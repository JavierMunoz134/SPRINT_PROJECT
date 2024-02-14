import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprint/model/user.dart';


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


  // Constructor explícito que invoca el constructor de la superclase
  AuthenticationBloc() : super(AuthenticationLoadingState());


  @override
  AuthState get initialState => AuthenticationLoadingState();


  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUpUser) {
      yield AuthenticationLoadingState();
      try {
        // Enviar correo electrónico de verificación
        await _auth.sendSignInLinkToEmail(
          email: event.email,
          actionCodeSettings: ActionCodeSettings(
            url: 'https://your-app-url.com', // URL profunda para redirigir después de la verificación
            handleCodeInApp: true, // Abre la aplicación automáticamente al hacer clic en el enlace
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
          link: event.verificationCode,
        );
        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        yield AuthenticationSuccessState(userCredential.user!);
      } catch (e) {
        yield AuthenticationFailureState(e.toString());
      }
    }
  }
}
