import 'package:flutter/material.dart';
import 'package:smartagro/components/navbar.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo com Gradiente Verde
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7DCC5C), // Verde mais claro no topo
              Color.fromARGB(
                255,
                49,
                153,
                52,
              ), // Verde um pouco mais escuro abaixo
            ],
          ),
        ),
        child: Column(
          children: [
            // PARTE SUPERIOR (Logo e Título)
            Expanded(
              flex: 55, // Ocupa cerca de 55% da tela
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Centralizado
                      Center(
                        child: Image.asset(
                          'images/logo.png',
                          height: 180, // Ajuste a altura conforme necessário
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 50),
                      // Textos alinhados à esquerda
                      Text(
                        'Bem-Vindo ao',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'SmartAgro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                          letterSpacing:
                              -1.5, // Deixa a fonte mais "junta" como na imagem
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // PARTE INFERIOR (Card Branco)
            Expanded(
              flex: 35, // Ocupa cerca de 45% da tela
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Texto Descritivo
                    const Text(
                      'Monitoramento inteligente para sua plantação. Acompanhe sensores e controle a irrigação de forma simples e eficiente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.5, // Espaçamento entre as linhas
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Botão "Começar"
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        // No seu arquivo original, dentro do ElevatedButton:
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NavBar(),
                            ), // Chama a tela de login
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF009650,
                          ), // Verde escuro do botão
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'Começar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}