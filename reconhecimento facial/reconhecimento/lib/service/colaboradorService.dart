import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart'; // Para criar arquivos temporários
import 'package:flutter/material.dart';
import 'package:reconhecimento/pages/MainPage.dart';

class ColaboradorService {
  final String baseUrl;

  ColaboradorService(this.baseUrl);

  /// Atualiza os dados de um colaborador na API.
  Future<void> atualizarColaborador({
    required String cnpj,
    required String matricula,
    required Map<String, String> campos,
    required Uint8List? imagemBytes,
  }) async {
    final url = '$baseUrl/colaboradores/upload/$cnpj/$matricula';
    var request = http.MultipartRequest('PUT', Uri.parse(url));

    // Adiciona os campos ao request
    campos.forEach((key, value) {
      request.fields[key] = value;
    });

    // Adiciona a imagem ao request, se houver
    if (!kIsWeb && imagemBytes != null) {
      // Salva os bytes em um arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/imagem_temp.jpg');
      await file.writeAsBytes(imagemBytes);

      var imagemFile = await http.MultipartFile.fromPath(
        'imagem',
        file.path,
        filename: 'imagem.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imagemFile);
    } else if (kIsWeb && imagemBytes != null) {
      var imagemFile = http.MultipartFile.fromBytes(
        'imagem',
        imagemBytes,
        filename: 'imagem.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imagemFile);
    }

    var response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao atualizar colaborador: ${response.statusCode}');
    }
  }

 Future<List<Map<String, dynamic>>> buscarTodosColaboradores() async {
    final response = await http.get(Uri.parse('$baseUrl/colaboradores'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar colaboradores');
    }
  }

  Future<Map<String, dynamic>> buscarColaborador(String cnpj, String matricula) async {
    final url = '$baseUrl/colaboradores/$cnpj/$matricula';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Colaborador não encontrado');
    } else {
      throw Exception('Erro ao buscar colaborador');
    }
  }
  
Future<void> cadastrarColaborador({
    required String cnpj,
    required Map<String, String> campos,
    required Uint8List? imagemBytes,
    required bool isAdm,
  }) async {
    const String url = 'http://localhost:3000/colaboradores';
    print("Iniciando processo de cadastro...");

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Adiciona os campos ao request
    campos.forEach((key, value) {
      request.fields[key] = value;
    });

    // Adiciona a imagem ao request, se houver
    if (!kIsWeb && imagemBytes != null) {
      // Salva os bytes em um arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/imagem_temp.jpg');
      await file.writeAsBytes(imagemBytes);

      var imagemFile = await http.MultipartFile.fromPath(
        'imagem',
        file.path,
        filename: 'imagem.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imagemFile);
    } else if (kIsWeb && imagemBytes != null) {
      var imagemFile = http.MultipartFile.fromBytes(
        'imagem',
        imagemBytes,
        filename: 'imagem.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imagemFile);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Resposta do servidor: $responseBody");

      if (response.statusCode == 201) {
        print('Colaborador cadastrado com sucesso!');
      } else {
        throw Exception('Erro ao cadastrar: $responseBody');
      }
    } catch (error) {
      throw Exception('Erro ao conectar com a API: $error');
    }
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


}