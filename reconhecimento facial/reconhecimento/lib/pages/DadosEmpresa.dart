import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class DadosEmpresaPage extends StatefulWidget {
  final String cnpj;
  
  const DadosEmpresaPage({required this.cnpj});

  @override
  State<DadosEmpresaPage> createState() => _DadosEmpresaPageState();
}

class _DadosEmpresaPageState extends State<DadosEmpresaPage> {
  final cnpjController = MaskedTextController(mask: '00.000.000/0000-00');
  final cepController = MaskedTextController(mask: '00000-000');
   final TextEditingController _dataCriacaoController = TextEditingController();
 
  final TextEditingController _nomeFantasiaController = TextEditingController();
  final TextEditingController _estadoCidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _ruaAvenidaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();


  bool _isLoading = true; // Para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    cnpjController.text = widget.cnpj; // Preenche o CNPJ automaticamente
    _carregarDadosEmpresa(); // Busca os dados da empresa
  }
Future<void> _carregarDadosEmpresa() async {
    try {
      final empresaData = await fetchEmpresaData(widget.cnpj);

      setState(() {
        _nomeFantasiaController.text = empresaData['NomeFantasia'] ?? '';
        cepController.text = empresaData['CEP'] ?? '';
        _responsavelController.text = empresaData['Responsavel'] ?? '';
        _dataCriacaoController.text = empresaData['DataCriacao'] != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(empresaData['DataCriacao']))
            : '';
        _estadoCidadeController.text = empresaData['EstadoCidade'] ?? '';
        _bairroController.text = empresaData['Bairro'] ?? '';
        _ruaAvenidaController.text = empresaData['RuaAvenida'] ?? '';
        _numeroController.text = empresaData['Numero'] ?? '';
        _complementoController.text = empresaData['Complemento'] ?? '';
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

Future<Map<String, dynamic>> fetchEmpresaData(String cnpj) async {
  final url = Uri.parse("http://localhost:3000/empresa/get/$cnpj"); 
  print("Fazendo requisição para: $url"); // Log 1

  final response = await http.get(url);

  print("Resposta recebida: ${response.statusCode}"); // Log 2
  print("Corpo da resposta: ${response.body}"); // Log 3

  if (response.statusCode == 200) {
    return json.decode(response.body); // Retorna os dados da empresa
  } else if (response.statusCode == 404) {
    throw Exception('Empresa não encontrada');
  } else {
    throw Exception('Erro ao buscar empresa');
  }
}

  void _mostrarDialogoConfirmacao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text("Cancelar plano",
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              )),
          content: Text("Deseja mesmo cancelar esse plano?",
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem cancelar
              },
              child: Text("Voltar",
                  style: GoogleFonts.roboto(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Plano cancelado")),
                );
              },
              child: Text(
                "Cancelar Plano",
                style: TextStyle(color: Colors.red), // Deixa o botão vermelho
              ),
            ),
          ],
        );
      },
    );
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

  void _cadastrar() {
    // Exibe a notificação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dados atualizados com sucesso'),
        duration: Duration(seconds: 2),
      ),
    );

    // Limpa os campos preenchidos
    _nomeFantasiaController.clear();
    cnpjController.clear();
    _numeroController.clear();
    _responsavelController.clear();
    _bairroController.clear();
    _dataCriacaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 148, 177, 255),
        appBar: AppBar(
          title: Text("Dados da empresa", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 30, 112, 243),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white), // Ícone de três pontos
              onSelected: (value) {
                if (value == "cancelar") {
                  _mostrarDialogoConfirmacao(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "cancelar",
                  child: Text("Cancelar plano",
                      style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // Mostra um indicador de carregamento
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 15),

                      // Caixa com os campos de preenchimento
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 215, 221, 231),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Nome Fantasia:",
                                    style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _nomeFantasiaController,
                                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Nome Fantasia',
                                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("CNPJ: ",
                                    style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: cnpjController,
                                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'CNPJ',
                                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("CEP:",
                                    style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: cepController,
                                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'CEP',
                                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("Estado / Cidade :",
                                    style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _estadoCidadeController,
                                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Estado ou cidade',
                                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("Bairro :",
                                    style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _bairroController,
                                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Bairro: ',
                                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("Rua / Avenida :",
                                    style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _ruaAvenidaController,
                                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Rua / Avenida',
                                      labelStyle: TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
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
                                Text("Numero:",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _numeroController,
                                    style: TextStyle(color: Colors.black87),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Numero',
                                      labelStyle: TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("Complemento:",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _complementoController,
                                    style: TextStyle(color: Colors.black87),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Complemento',
                                      labelStyle: TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("Reponsavel: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _responsavelController,
                                    style: TextStyle(color: Colors.black87),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Reponsavel Legal',
                                      labelStyle: TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
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
                                Text("Data de Criação: ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Expanded(
                                  child: TextField(
                                    controller: _dataCriacaoController,
                                    readOnly: true,
                                    onTap: () => _selecionarData(
                                        context, _dataCriacaoController),
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText: 'Data de Criação',
                                      labelStyle: TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),

                      // Botão fora da caixa
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