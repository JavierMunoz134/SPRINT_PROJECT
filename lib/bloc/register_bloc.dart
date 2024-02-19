import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/register_repo.dart';
import 'package:sprint/repository/register_repo.dart';
import 'package:equatable/equatable.dart';

// Eventos
abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendPasswordlessEmail extends RegisterEvent {
  final String email;
  SendPasswordlessEmail(this.email);

  @override
  List<Object> get props => [email];


}

// Estados
abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<SendPasswordlessEmail>(_onSendPasswordlessEmail);
  }

  Future<void> _onSendPasswordlessEmail(SendPasswordlessEmail event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      //await quitado
       _authRepository.sendPasswordlessSignInLink(event.email);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}














