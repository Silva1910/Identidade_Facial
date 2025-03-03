import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart'; // Para máscaras de texto
import 'package:google_fonts/google_fonts.dart'; // Para fontes personalizadas
import 'package:flutter/services.dart'; // Para formatação de texto
import 'package:image_picker/image_picker.dart'; // Para selecionar imagens
import 'dart:io'; // Para trabalhar com arquivos
import 'package:flutter_image_compress/flutter_image_compress.dart'; // Para comprimir imagens
import 'package:http/http.dart' as http; // Para enviar requisições HTTP
import 'package:http_parser/http_parser.dart'; // Para definir o tipo de mídia
import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:image/image.dart' as img;

class Cadastropage extends StatefulWidget {
  final String cnpj;

  const Cadastropage({required this.cnpj});

  @override
  State<Cadastropage> createState() => _CadastropageState();
}


Future<File> compressImage(File file) async {
  final image = img.decodeImage(await file.readAsBytes());
  final resized = img.copyResize(image!, width: 800); // Redimensiona para 800px
  final compressed = File(file.path)..writeAsBytesSync(img.encodeJpg(resized, quality: 85));
  return compressed;
}


class _CadastropageState extends State<Cadastropage> {
  bool _isAdm = false;
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final rgController = MaskedTextController(mask: '00.000.000-0');
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _dataAdmissaoController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cargaHorariaController = TextEditingController();
  final TextEditingController ctpsController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  File? _imagemSelecionada;

  Uint8List? _imagemSelecionadaWeb; // Para armazenar a imagem na web
  Future<void> _selecionarImagem() async {
    print("Iniciando seleção de imagem...");
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      print("Imagem selecionada: ${imagem.path}");

      if (kIsWeb) {
        // Para Flutter Web
        final bytes = await imagem.readAsBytes();
        setState(() {
          _imagemSelecionadaWeb = bytes;
        });
        print("Imagem carregada na web: ${bytes.length} bytes");
      } else {
        // Para Mobile
        File imagemFile = File(imagem.path);

        if (await imagemFile.exists()) {
          print("Arquivo da imagem existe: ${imagemFile.path}");
          File? imagemComprimida = await _comprimirImagem(imagemFile);

          setState(() {
            _imagemSelecionada = imagemComprimida ??
                imagemFile; // Garante que a imagem seja atribuída mesmo se a compressão falhar
          });

          if (imagemComprimida != null) {
            print("Imagem comprimida salva em: ${imagemComprimida.path}");
          } else {
            print("Aviso: Usando a imagem original, pois a compressão falhou.");
          }
        } else {
          print("Erro: Arquivo da imagem não existe.");
        }
      }
    } else {
      print("Nenhuma imagem foi selecionada.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhuma imagem foi selecionada.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

// Converte a data de "DD/MM/YYYY" para "YYYY-MM-DD"
  String _formatarDataParaISO(String data) {
    final partes = data.split('/');
    if (partes.length == 3) {
      return "${partes[2]}-${partes[1]}-${partes[0]}";
    }
    return data; // Retorna a data original se não puder ser formatada
  }

  Future<File?> _comprimirImagem(File file) async {
    final caminhoComprimido = '${file.path}_comprimida.jpg';
    print("Caminho da imagem comprimida: $caminhoComprimido");

    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        caminhoComprimido,
        quality: 50, // Ajuste a qualidade conforme necessário
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        print("Imagem comprimida salva em: ${result.path}");
        return File(result.path);
      } else {
        print("Erro: A compressão retornou null.");
        return null;
      }
    } catch (e) {
      print("Erro ao comprimir a imagem: $e");
      return null;
    }
  }
Future<void> _cadastrar() async {
  const String url = 'http://localhost:3000/colaboradores';
  print("Iniciando processo de cadastro...");

  if (nomeController.text.isEmpty ||
      cpfController.text.isEmpty ||
      rgController.text.isEmpty ||
      _dataNascimentoController.text.isEmpty ||
      _dataAdmissaoController.text.isEmpty ||
      matriculaController.text.isEmpty ||
      ctpsController.text.isEmpty ||
      nisController.text.isEmpty ||
      cargaHorariaController.text.isEmpty ||
      cargoController.text.isEmpty ||
      _senhaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todos os campos obrigatórios devem ser preenchidos.'), duration: Duration(seconds: 2)),
    );
    return;
  }

  if (!kIsWeb && _imagemSelecionada == null || (kIsWeb && _imagemSelecionadaWeb == null)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, selecione uma imagem antes de cadastrar.'), duration: Duration(seconds: 2)),
    );
    return;
  }

  int cargaHoraria = int.parse(cargaHorariaController.text);
  var request = http.MultipartRequest('POST', Uri.parse(url));

  request.fields['Matricula'] = matriculaController.text;
  request.fields['Nome'] = nomeController.text;
  request.fields['CPF'] = cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
  request.fields['RG'] = rgController.text.replaceAll(RegExp(r'[^0-9]'), '');
  request.fields['DataNascimento'] = _formatarDataParaISO(_dataNascimentoController.text);
  request.fields['DataAdmissao'] = _formatarDataParaISO(_dataAdmissaoController.text);
  request.fields['NIS'] = nisController.text;
  request.fields['CTPS'] = ctpsController.text;
  request.fields['CargaHoraria'] = cargaHoraria.toString();
  request.fields['Cargo'] = cargoController.text;
  request.fields['CNPJ'] = widget.cnpj;
  request.fields['Senha'] = _senhaController.text;
  request.fields['IsAdm'] = _isAdm.toString();

  if (!kIsWeb) {
    File compressedImage = await compressImage(_imagemSelecionada!);
    var imagemFile = await http.MultipartFile.fromPath(
      'imagem',
      compressedImage.path,
      filename: 'imagem.jpg',
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(imagemFile);
  } else {
    var imagemBytes = http.MultipartFile.fromBytes(
      'imagem',
      _imagemSelecionadaWeb!,
      filename: 'imagem.jpg',
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(imagemBytes);
  }

  try {
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print("Resposta do servidor: $responseBody");

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Colaborador cadastrado com sucesso!'), duration: Duration(seconds: 2)),
      );
      nomeController.clear();
      cpfController.clear();
      rgController.clear();
      matriculaController.clear();
      ctpsController.clear();
      _dataNascimentoController.clear();
      _dataAdmissaoController.clear();
      nisController.clear();
      cargoController.clear();
      setState(() {
        _imagemSelecionada = null;
        _imagemSelecionadaWeb = null;
        _isAdm = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $responseBody'), duration: Duration(seconds: 2)),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao conectar com a API: $error'), duration: Duration(seconds: 2)),
    );
  }
}

  Future<void> _selecionarData(
      BuildContext context, TextEditingController controller) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Altere o tema se necessário
          child: child!,
        );
      },
    );

    if (dataSelecionada != null) {
      setState(() {
        controller.text = "${dataSelecionada.day.toString().padLeft(2, '0')}/"
            "${dataSelecionada.month.toString().padLeft(2, '0')}/"
            "${dataSelecionada.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(2255, 148, 177, 255),
        appBar: AppBar(
          title: Text("Cadastro de Colaboradores",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 30, 112, 243),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: const Color.fromARGB(255, 4, 47, 115),
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 2, 44, 79)
                                  .withOpacity(0.8),
                              offset: const Offset(0, 6),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: _selecionarImagem,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                          child: kIsWeb
                                              ? _imagemSelecionadaWeb != null
                                                  ? ClipOval(
                                                      child: Image.memory(
                                                        _imagemSelecionadaWeb!,
                                                        fit: BoxFit.cover,
                                                        width: 200,
                                                        height: 200,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.add_a_photo,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      size: 50,
                                                    )
                                              : _imagemSelecionada != null
                                                  ? ClipOval(
                                                      child: Image.file(
                                                        _imagemSelecionada!,
                                                        fit: BoxFit.cover,
                                                        width: 200,
                                                        height: 200,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.add_a_photo,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      size: 50,
                                                    ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Clique para adicionar uma imagem",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Nome: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: nomeController,
                                    style: TextStyle(color: Colors.black),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Nome',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("CPF: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: cpfController,
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'CPF',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Data Nasc: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _dataNascimentoController,
                                    readOnly: true,
                                    onTap: () => _selecionarData(
                                        context, _dataNascimentoController),
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Data de Nascimento',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("RG: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: rgController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'RG',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Matricula: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: matriculaController,
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Apenas números
                                      LengthLimitingTextInputFormatter(
                                          50), // Limite de 50 caracteres
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Matricula',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("CTPS: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: ctpsController,
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Apenas números
                                      LengthLimitingTextInputFormatter(
                                          50), // Limite de 50 caracteres
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'CTPS',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("NIS: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: nisController,
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Apenas números
                                      LengthLimitingTextInputFormatter(
                                          50), // Limite de 50 caracteres
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'NIS',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Carga Horaria: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: cargaHorariaController,
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Apenas números
                                      LengthLimitingTextInputFormatter(
                                          50), // Limite de 50 caracteres
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Carga Horaria',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cargo: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: cargoController,
                                    style: TextStyle(color: Colors.black),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Cargo',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ], //children
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Data de Admissão: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _dataAdmissaoController,
                                    readOnly: true,
                                    onTap: () => _selecionarData(
                                        context, _dataAdmissaoController),
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Data de Admissão',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Senha : ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _senhaController,
                                    style: TextStyle(color: Colors.black),
                                      inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                      ],
                                    decoration: InputDecoration(
                                      labelText: 'Senha do colaborador',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Administrador: ",
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Checkbox(
                                  value: _isAdm,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isAdm = value ?? false;
                                    });
                                  },
                                ),
                                Text(_isAdm
                                    ? "Sim"
                                    : "Não"), // Texto dinâmico ao lado do checkbox
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 33, 255),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Cadastrar',
                      style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 255, 255, 255),
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
      ),
    );
  }
}
