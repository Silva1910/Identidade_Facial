import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http; // Para enviar requisições HTTP
import 'package:intl/intl.dart';
import 'dart:convert';

class CadastroEmpresaPage extends StatefulWidget {
  const CadastroEmpresaPage({super.key});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  final cnpjController = MaskedTextController(mask: '00.000.000/0000-00');
  
  final cepController = MaskedTextController(mask: '00000-000');
  final TextEditingController _dataCriacaoController = TextEditingController();
  
  final TextEditingController _responsavelController = TextEditingController();
 final TextEditingController _cepController = TextEditingController();
 final TextEditingController _nomeFantasiaController = TextEditingController();
final TextEditingController _estadoCidadeController = TextEditingController();
final TextEditingController _bairroController = TextEditingController();
final TextEditingController _ruaAvenidaController = TextEditingController();
final TextEditingController _numeroController = TextEditingController();
final TextEditingController _complementoController = TextEditingController();
 
Future<void> _selecionarData(BuildContext context, TextEditingController controller) async {
  // Abre o DatePicker
  DateTime? dataSelecionada = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Data inicial (hoje)
    firstDate: DateTime(1900), // Data mínima permitida
    lastDate: DateTime.now(), // Data máxima permitida (hoje)
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(), // Tema do DatePicker (opcional)
        child: child!,
      );
    },
  );

  // Se o usuário selecionou uma data
  if (dataSelecionada != null) {
    // Formata a data no formato dd/MM/yyyy
    String dataFormatada = "${dataSelecionada.day.toString().padLeft(2, '0')}/"
        "${dataSelecionada.month.toString().padLeft(2, '0')}/"
        "${dataSelecionada.year}";

    // Atualiza o TextField com a data formatada
    setState(() {
      controller.text = dataFormatada;
    });
  }
}

Future<String?> _mostrarDialogoSenha(BuildContext context) async {
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  return await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: senhaController,
              obscureText: true, // Para ocultar a senha
              decoration: InputDecoration(
                labelText: 'nova senha',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmarSenhaController,
              obscureText: true, // Para ocultar a senha
              decoration: InputDecoration(
                labelText: 'repita a senha',
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (senhaController.text == confirmarSenhaController.text) {
                    Navigator.pop(context, senhaController.text); // Retorna a senha
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("As senhas não coincidem!")),
                    );
                  }
                },
                child: Text('Confirmar'),
              ),
            ),
          ],
        ),
      );
    },
  );
}
Future<void> _cadastrar() async {
  try {
    final senha = await _mostrarDialogoSenha(context);

    if (senha == null || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Senha é obrigatória!")),
      );
      return;
    }

    var url = Uri.parse("http://localhost:3000/empresa");

    // Convertendo e formatando a data corretamente antes de enviar
    String? dataCriacao;
    if (_dataCriacaoController.text.isNotEmpty) {
      try {
        List<String> partes = _dataCriacaoController.text.split("/");
        if (partes.length == 3) {
          int dia = int.parse(partes[0]);
          int mes = int.parse(partes[1]);
          int ano = int.parse(partes[2]);
          DateTime dataCriacaoParsed = DateTime(ano, mes, dia);
          dataCriacao = DateFormat('yyyy-MM-dd').format(dataCriacaoParsed);
        }
      } catch (e) {
        print("Erro ao converter data: $e");
      }
    }

    print("DataCriacao antes de enviar: $dataCriacao");

    var body = {
      "NomeFantasia": _nomeFantasiaController.text,
      "CNPJ": cnpjController.text.replaceAll(RegExp(r'\D'), ''),
      "CEP": _cepController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      "EstadoCidade": _estadoCidadeController.text,
      "Bairro": _bairroController.text,
      "RuaAvenida": _ruaAvenidaController.text,
      "Numero": _numeroController.text,
      "Complemento": _complementoController.text,
      "Responsavel": _responsavelController.text,
      "DataCriacao": dataCriacao,
      "IsAdm": true,
      "Senha": senha,
    };

    print("Corpo da requisição: \${jsonEncode(body)}");

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print("Empresa cadastrada com sucesso: \${response.body}");

      _nomeFantasiaController.clear();
      cnpjController.clear();
      _cepController.clear();
      _estadoCidadeController.clear();
      _bairroController.clear();
      _ruaAvenidaController.clear();
      _numeroController.clear();
      _complementoController.clear();
      _responsavelController.clear();
      _dataCriacaoController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );
    } else {
      print("Erro ao cadastrar empresa: \${response.statusCode}, Detalhes: \${response.body}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar empresa: \${response.body}")),
      );
    }
  } catch (e) {
    print("Erro inesperado: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro inesperado ao cadastrar. Tente novamente!")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 148, 177, 255),
        appBar: AppBar(
          title: Text("Cadastre sua empresa",
          style: TextStyle(color: Colors.white) 
          ),
         backgroundColor: const Color.fromARGB(255, 30, 112, 243),
        ),
        
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
              SizedBox(height: 15),
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
        color: const Color.fromARGB(255, 2, 44, 79).withOpacity(0.8),
        offset: const Offset(0, 6),
        blurRadius: 15,
      ),
    ],
  ),
  child: Row(
     mainAxisAlignment: MainAxisAlignment.center, // Cent
    children: [
      Expanded(
        child: Text(
          "Venha conhecer o PONTO-VIEW a ferramenta que vai simplificar o seu registro de ponto",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            
          ),
        ),
      ),
    
    ],
  ),
),
SizedBox(height: 15),

                // Caixa com os campos de preenchimento
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 232, 232),
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
                              style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
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
                          Text("CEP:",
                              style: GoogleFonts.roboto(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Expanded(
                            child: TextField(
                              controller:  _cepController ,
                              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                labelText: 'CEP',
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
                      ),SizedBox(height: 8),
                      
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
                      ),SizedBox(height: 8),
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
                      ),SizedBox(height: 8),
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
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),SizedBox(height: 8),
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Numero:",
                              style: GoogleFonts.roboto(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Expanded(
                            child: TextField(
                              controller: _numeroController,
                              style: TextStyle(color: Colors.white),
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
                      ),SizedBox(height: 8),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Complemento:",
                              style: GoogleFonts.roboto(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Expanded(
                            child: TextField(
                              controller: _complementoController,
                              style: TextStyle(color: Colors.white),
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
                      ),SizedBox(height: 8),
                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Reponsavel: ",
                              style: GoogleFonts.roboto(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Expanded(
                            child: TextField(
                              controller: _responsavelController,
                              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
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
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Expanded(
                            child: TextField(
                              controller: _dataCriacaoController,
                              readOnly: true,
                              onTap: () => _selecionarData(
                                  context, _dataCriacaoController),
                              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
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
                      backgroundColor: const Color.fromARGB(255, 77, 94, 226),
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
