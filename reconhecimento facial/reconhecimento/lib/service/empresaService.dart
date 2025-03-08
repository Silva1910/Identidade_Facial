
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:reconhecimento/pages/MainPageEmpresa.dart';

class Empresaservice {
  final String baseUrl;

  Empresaservice(this.baseUrl);



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

}