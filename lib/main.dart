import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sprint/data/odoo_connect.dart';
import 'package:sprint/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sprint/repository/register_repo.dart';
import 'package:sprint/bloc/register_bloc.dart';

import 'firebase_options.dart';

Future main() async {
  await dotenv.load(fileName: "./assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  OdooConnect.initialize();  // Asegúrate de que esta sea la inicialización correcta para tu caso

  runApp(
    RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => RegisterBloc(RepositoryProvider.of<AuthRepository>(context)),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprint Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const SafeArea(
        child: LoginScreen(),
      ),
    );
  }
}