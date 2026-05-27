import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Importa o pacote dotenv
//import 'package:smartagro/screens/home.dart';
import 'package:smartagro/screens/splashscreen.dart';

void main() async {
  // 2. Garante que o Flutter inicialize os bindings antes de carregar o arquivo assíncrono
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 3. Carrega o arquivo de configuração .env
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Caso o arquivo não seja encontrado, exibe um aviso no console
    debugPrint("Aviso: Não foi possível carregar o arquivo .env: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: const Splashscreen(),
    );
  }
}