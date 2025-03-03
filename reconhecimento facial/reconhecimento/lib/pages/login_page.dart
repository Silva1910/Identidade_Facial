import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:reconhecimento/pages/MainPage.dart';
import 'package:reconhecimento/pages/MainPageEmpresa.dart';

import 'package:reconhecimento/pages/CadastroEmpresaPage.dart';
import 'package:reconhecimento/pages/resetPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool IsAdm = false;
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode senhaFocusNode = FocusNode();
  bool isObscureText = true;

  @override
  void initState() {
    super.initState();
    // Adiciona listeners para os FocusNode
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        print("Campo de matrícula em foco");
      }
    });
    senhaFocusNode.addListener(() {
      if (senhaFocusNode.hasFocus) {
        print("Campo de senha em foco");
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    senhaFocusNode.dispose();
    matriculaController.dispose();
    senhaController.dispose();
    super.dispose();

  }

Future<void> loginColaborador(String login, String senha, BuildContext context) async {
  final url = Uri.parse("http://localhost:3000/colaborador/login"); // Use o IP correto
  final body = {'login': login, 'senha': senha};

  print("Corpo da requisição de login (colaborador): ${jsonEncode(body)}"); // Log do corpo da requisição

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("Resposta do servidor (colaborador): ${response.statusCode}, ${response.body}"); // Log da resposta

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login efetuado com sucesso")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainPage(isAdm: data['isAdm']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro no servidor")),
      );
    }
  } catch (e) {
    print("Erro durante a requisição (colaborador): $e"); // Log de erro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro durante a requisição")),
    );
  }
}
 Future<void> loginEmpresa(String cnpj, String senha, BuildContext context) async {
  print("Função loginEmpresa chamada com CNPJ: $cnpj e Senha: $senha"); // Log de chamada da função

  // Substitua pelo IP correto da sua máquina
  final url = Uri.parse("http://localhost:3000/empresa/login");
  final body = {'cnpj': cnpj, 'senha': senha};

  print("Corpo da requisição de login (empresa): ${jsonEncode(body)}"); // Log do corpo da requisição

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("Resposta do servidor (empresa): ${response.statusCode}, ${response.body}"); // Log da resposta

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login efetuado com sucesso")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainPageEmpresa(
              isAdm: data['isAdm'],
              cnpj: cnpj, // Passa o CNPJ para a MainPageEmpresa
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro no servidor")),
      );
    }
  } catch (e) {
    print("Erro durante a requisição (empresa): $e"); // Log de erro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro durante a requisição")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 215, 221, 231),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            child: Image.asset(
                              'assets/1231099.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                const Text(
                  "PONTO-VIEW",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 50),
                const Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: matriculaController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 3, 33, 255),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 3, 33, 255),
                        ),
                      ),
                      hintText: "Matricula",
                      hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 3, 33, 255),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: senhaController,
                    focusNode: senhaFocusNode,
                    obscureText: isObscureText,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 3, 33, 255),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 3, 33, 255),
                        ),
                      ),
                      hintText: "Senha",
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 3, 33, 255),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                        child: Icon(
                          isObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      final matricula = matriculaController.text.trim();
                      final senha = senhaController.text.trim();

                      if (matricula.isEmpty || senha.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Matrícula e senha são obrigatórios!")),
                        );
                        return;
                      }

                      if (matricula.length == 14) {
                        // Login de empresa
                        loginEmpresa(matricula, senha, context);
                      } else {
                        // Login de colaborador
                        loginColaborador(matricula, senha, context);
                      }
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 3, 33, 255),
                      ),
                    ),
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Resetpage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    child: const Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CadastroEmpresaPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    child: Text(
                      "Contrate nosso serviços",
                      style: TextStyle(
                        color: Color.fromARGB(223, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}