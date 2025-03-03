import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Resetpage extends StatefulWidget {
  const Resetpage({super.key});

  @override
  State<Resetpage> createState() => _ResetpageState();
}

class _ResetpageState extends State<Resetpage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),

        appBar: AppBar(
          title: Text(
            "Reset de Senha",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true, // Centraliza o título
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Voltar para a tela anterior
            },
          ),
        ),

        body: Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: const Color.fromARGB(255, 237, 198, 42),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 237, 198, 42)
                      .withOpacity(0.8),
                  offset: const Offset(0, 6),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Mantém apenas o necessário de altura
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícone de atenção
                Icon(
                  Icons.warning_amber,
                  color: Color.fromARGB(255, 237, 198, 42),
                  size: 64.0, // Tamanho maior para destaque
                ),
                const SizedBox(height: 16), // Espaçamento

                // Texto
                Text(
                  "Entre em contato com o seu RH e peça o reset da sua senha",
                  textAlign: TextAlign.center, // Centraliza o texto
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
