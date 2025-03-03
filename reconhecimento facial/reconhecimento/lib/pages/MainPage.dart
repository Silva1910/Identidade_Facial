import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:reconhecimento/pages/PerfilPage.dart';
import 'package:reconhecimento/pages/RelacaoPage.dart';
import 'package:reconhecimento/pages/login_page.dart';
import 'package:reconhecimento/pages/FaceDetectionCameraScreen.dart';
import 'package:reconhecimento/pages/CalendarPage.dart';

class MainPage extends StatefulWidget {
  final bool isAdm;
  const MainPage({super.key, required this.isAdm});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
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
                        leading: const Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Home",
                          style: GoogleFonts.roboto(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainPage(isAdm: widget.isAdm),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.access_time_filled_sharp,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Registre seu ponto",
                          style: GoogleFonts.roboto(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FaceDetectionCameraScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.calendar_month_outlined,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Relação de Registros",
                          style: GoogleFonts.roboto(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onTap: () {
                         // Navigator.of(context).push(
                   //         MaterialPageRoute(
                        //      builder: (context) => CalendarPage(),
                     //       ),
                       //   );
                        },
                      ),
                       if (!widget.isAdm) SizedBox(height: 15),
                       if (!widget.isAdm)
                      ListTile(
                        leading: const Icon(Icons.supervised_user_circle,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Perfil",
                          style: GoogleFonts.roboto(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onTap: () {
                        //  Navigator.of(context).push(
                         //   MaterialPageRoute(
                         //     builder: (context) => const PerfilPage(),
                         //   ),
                      //    );
                        },
                      ),
 
     
                      if (widget.isAdm) SizedBox(height: 15),
                      if (widget.isAdm)
                        ListTile(
                          leading: const Icon(Icons.people, color: Color.fromARGB(255, 0, 0, 0)),
                          title: Text(
                            "Relacao de colaboradores",
                            style: GoogleFonts.roboto(color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          onTap: () {
                        //    Navigator.of(context).push(
                        //      MaterialPageRoute(
                      //          builder: (context) =>  RelacaoPage(),
                          //    ),
                          //  );
                          },
                        ),
                      SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app_sharp,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(
                          "Sair",
                          style: GoogleFonts.roboto(color: const Color.fromARGB(255, 0, 0, 0)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                                "Registre seu ponto",
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
                          const SizedBox(height:8 ),
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
                                        FaceDetectionCameraScreen()),
                              );
                            },
                            child: Text(
                              "Acessar Ponto",
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
                                "Histórico de ponto",
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
                      //        Navigator.push(
                              //  context,
                          //      MaterialPageRoute(
                              //      builder: (context) => CalendarPage()),
                    //          );
                            },
                            child: Text(
                              "Histórico de Ponto",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Container(
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
                                "Dados complementares ",
                                style: GoogleFonts.roboto(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center ,
                              ),
                               const SizedBox(width: 8),
                              Icon(
                                Icons.remember_me_outlined,
                                color: Color.fromARGB(255, 29, 80, 163),
                                size: 28.0,
                              ),
                              
                              
                              
                              ],
                              ),
                              const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_people_rounded,
                                      color: const Color.fromARGB(255, 29, 80, 163),
                                      size: 20.0,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Nome: ",
                                      style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Fulano da Silva Santos",
                                        style: GoogleFonts.roboto(
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_iphone_outlined,
                                      color: const Color.fromARGB(255, 29, 80, 163),
                                      size: 20.0,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Telefone: ",
                                      style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "(11) 9 59355141",
                                        style: GoogleFonts.roboto(
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.assignment_outlined,
                                      color: const Color.fromARGB(255, 29, 80, 163),
                                      size: 20.0,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Matrícula: ",
                                      style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "123",
                                        style: GoogleFonts.roboto(
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: const Color.fromARGB(255, 29, 80, 163),
                                      size: 20.0,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Saldo banco hr: ",
                                      style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "X",
                                        style: GoogleFonts.roboto(
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
       
                              ],
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  ],
                ),
              ]
              ),
  
            ),
          ),
        ),
    
    );
  
  }
}