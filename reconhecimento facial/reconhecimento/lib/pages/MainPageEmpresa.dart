import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:reconhecimento/pages/CadastroPage.dart';
import 'package:reconhecimento/pages/DadosEmpresa.dart';
import 'package:reconhecimento/pages/RelacaoPage.dart';
import 'package:reconhecimento/pages/login_page.dart';

class MainPageEmpresa extends StatefulWidget {
  final bool isAdm;
  final String cnpj;
  const MainPageEmpresa({super.key, required this.isAdm, required this.cnpj});

  @override
  State<MainPageEmpresa> createState() => MainPageEmpresaState();
}

class MainPageEmpresaState extends State<MainPageEmpresa> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 215, 221, 231),
        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 30, 112, 243),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 30, 112, 243),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Menu",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Color.fromARGB(255, 215, 221, 231),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Home",
                          style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MainPageEmpresa(
                                  isAdm: widget.isAdm, cnpj: widget.cnpj),
                            ),
                          );
                        },
                      ),
                      if (widget.isAdm) SizedBox(height: 15),
                      if (widget.isAdm)
                        ListTile(
                          leading: const Icon(Icons.business_outlined,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          title: Text(
                            "Dados da Empresa",
                            style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DadosEmpresaPage(cnpj: widget.cnpj),
                              ),
                            );
                          },
                        ),
                      if (widget.isAdm) SizedBox(height: 15),
                      if (widget.isAdm)
                        ListTile(
                          leading: const Icon(Icons.assignment_outlined,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          title: Text(
                            "Cadastro de colaboradores",
                            style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    Cadastropage(cnpj: widget.cnpj),
                              ),
                            );
                          },
                        ),
                      if (widget.isAdm) SizedBox(height: 15),
                      if (widget.isAdm)
                        ListTile(
                          leading: const Icon(Icons.people,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          title: Text(
                            "Relação de colaboradores",
                            style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RelacaoPage(cnpj: widget.cnpj),
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app_sharp,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Sair",
                          style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 20),
              Text(
                "PONTO-VIEW o seu sistema de ponto",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 215, 221, 231),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 22, 57),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 22, 57)
                              .withOpacity(0.8),
                          offset: const Offset(0, 6),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Cadastro de Colaboradores",
                              style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time_filled_sharp,
                              color: Color.fromARGB(255, 29, 80, 163),
                              size: 22.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Transforme sua jornada de trabalho em algo simples e ágil com Work-Time",
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 29, 80, 163),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Cadastropage(
                                    cnpj:
                                        widget.cnpj), // Use o nome do parâmetro
                              ),
                            );
                          },
                          child: Text(
                            "Cadastro",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 215, 221, 231),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 22, 57),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 22, 57)
                              .withOpacity(0.8),
                          offset: const Offset(0, 6),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Relacao de Colaboradores",
                              style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit_calendar_rounded,
                              color: Color.fromARGB(255, 29, 80, 163),
                              size: 22.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Work-Time, a ferramenta que mudará sua concepção de registro de ponto",
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 29, 80, 163),
                            foregroundColor: Color.fromARGB(255, 215, 221, 231),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RelacaoPage(cnpj: widget.cnpj)),
                            );
                          },
                          child: Text(
                            "Relação",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 215, 221, 231),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 22, 57),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 22, 57)
                              .withOpacity(0.8),
                          offset: const Offset(0, 6),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dados da Empresa",
                              style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.donut_small_sharp,
                              color: Color.fromARGB(255, 29, 80, 163),
                              size: 22.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Atualize, Corrija e siga aumentando a perfomance com o Work-Time",
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 29, 80, 163),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DadosEmpresaPage(cnpj: widget.cnpj)),
                            );
                          },
                          child: Text(
                            "Dados da Empresa",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
