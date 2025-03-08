import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart'; // Para máscaras de texto
import 'package:google_fonts/google_fonts.dart'; // Para fontes personalizadas
import 'package:flutter/services.dart'; // Para formatação de texto
import 'package:image_picker/image_picker.dart'; // Para selecionar imagens
import 'dart:io'; // Para trabalhar com arquivos
import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:reconhecimento/service/colaboradorService.dart';
import 'package:reconhecimento/utils/image_utils.dart';
import 'package:reconhecimento/utils/date_utils.dart';

class AtualizarColaboradorpage extends StatefulWidget {
  final String cnpj;
  final String matricula;

  const AtualizarColaboradorpage({required this.matricula, required this.cnpj});

  @override
  State<AtualizarColaboradorpage> createState() =>
      _AtualizarColaboradorpageState();
}

Future<File> compressImage(File file) async {
  final image = img.decodeImage(await file.readAsBytes());
  final resized = img.copyResize(image!, width: 800); // Redimensiona para 800px
  final compressed = File(file.path)
    ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));
  return compressed;
}

class _AtualizarColaboradorpageState extends State<AtualizarColaboradorpage> {
  bool _isAdm = false;
  bool _isLoading = true; // Para controlar o estado de carregamento
  ColaboradorService _colaboradorService = ColaboradorService('http://localhost:3000');
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
  Uint8List? _imagemBytes; // Para armazenar a imagem carregada da API

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
          File? imagemComprimida = await ImageUtils.comprimirImagem(imagemFile);;

          setState(() {
            _imagemSelecionada = imagemComprimida ?? imagemFile;
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

  
  Future<void> _updateColaborador() async {
    try {
      // Prepara os campos
      Map<String, String> campos = {
        'Nome': nomeController.text,
        'CPF': cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        'RG': rgController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        'DataNascimento': DateUtilits.formatarDataParaISO(_dataNascimentoController.text),
        'DataAdmissao': DateUtilits.formatarDataParaISO(_dataAdmissaoController.text),
        'NIS': nisController.text,
        'CTPS': ctpsController.text,
        'CargaHoraria': cargaHorariaController.text,
        'Cargo': cargoController.text,
        'CNPJ': widget.cnpj,
        'Senha': _senhaController.text,
        'IsAdm': _isAdm.toString(),
      };

      // Obtém os bytes da imagem
      Uint8List? imagemBytes = _imagemSelecionadaWeb ?? await _imagemSelecionada?.readAsBytes();

      // Chama o método atualizarColaborador
      await _colaboradorService.atualizarColaborador(
        cnpj: widget.cnpj,
        matricula: widget.matricula,
        campos: campos,
        imagemBytes: imagemBytes,
      );

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Colaborador atualizado com sucesso!')),
      );
 setState(() {
      nomeController.clear();
      cpfController.clear();
      rgController.clear();
      matriculaController.clear();
      ctpsController.clear();
      _dataNascimentoController.clear();
      _dataAdmissaoController.clear();
      cargaHorariaController.clear();
      nisController.clear();
      cargoController.clear();
      _senhaController.clear();
      _imagemSelecionada = null;
      _imagemSelecionadaWeb = null;
      _imagemBytes = null; // Limpa a imagem carregada da API
      _isAdm = false;
    });



    } catch (e) {
      // Exibe uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar colaborador: $e')),
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

Future<void> _carregarDadosColaborador() async {
    try {
        final colaboradorService = ColaboradorService('http://localhost:3000');
     final colaboradorData = await colaboradorService.buscarColaborador(widget.cnpj, widget.matricula);
      setState(() {
        nomeController.text = colaboradorData['Nome'] ?? '';
        cpfController.text = colaboradorData['CPF'] ?? '';
        rgController.text = colaboradorData['RG'] ?? '';
        _dataNascimentoController.text =
            colaboradorData['DataNascimento'] != null
                ? DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(colaboradorData['DataNascimento']))
                : '';
        _dataAdmissaoController.text = colaboradorData['DataAdmissao'] != null
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(colaboradorData['DataAdmissao']))
            : '';
        cargaHorariaController.text =
            colaboradorData['CargaHoraria']?.toString() ?? '';
        ctpsController.text = colaboradorData['CTPS'] ?? '';
        matriculaController.text = colaboradorData['Matricula'] ?? '';
        cargoController.text = colaboradorData['Cargo'] ?? '';
        nisController.text = colaboradorData['NIS'] ?? '';
        _senhaController.text = colaboradorData['Senha'] ?? '';

        // Se a API retorna a imagem em base64, convertemos para Uint8List
        if (colaboradorData['imagem'] != null && colaboradorData['imagem'] is String) {
          _imagemBytes = base64Decode(colaboradorData['imagem']);
        } else {
          _imagemBytes = null;
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }






  @override
  void initState() {
    super.initState();
    _carregarDadosColaborador(); 
      _colaboradorService = ColaboradorService('http://localhost:3000');// Busca os dados da empresa
  }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(2255, 148, 177, 255),
        appBar: AppBar(
          title: Text("Atualizar dados do Colaborador",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 30, 112, 243),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(), // Indicador de carregamento
              )
            : SingleChildScrollView(
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
                                                child: _imagemBytes != null
                                                    ? ClipOval(
                                                        child: Image.memory(
                                                          _imagemBytes!,
                                                          fit: BoxFit.cover,
                                                          width: 200,
                                                          height: 200,
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.black,
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
                                            LengthLimitingTextInputFormatter(
                                                50),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Nome',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                          onTap: () => _selecionarData(context,
                                              _dataNascimentoController),
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: 'Data de Nascimento',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                            LengthLimitingTextInputFormatter(
                                                50),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Cargo',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                            LengthLimitingTextInputFormatter(
                                                50),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Senha do colaborador',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                         onPressed: _updateColaborador,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 33, 255),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: Text(
                            'Atualizar',
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
