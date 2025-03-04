import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



class PerfilPage extends StatefulWidget {
  final String matricula;
  final String cnpj;
  const PerfilPage({required this.matricula, required this.cnpj});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nome = '';
  String cpf = '';
  String rg = '';
  String dataNascimento = '';
  String ctps = '';
  String matricula = '';
  String cargo = '';
  String nis = '';
  String dataAdmissao = '';
  Uint8List? _imagemBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosColaborador();
  }

  Future<void> _carregarDadosColaborador() async {
    try {
      final colaboradorData = await fetchColaborador(widget.cnpj, widget.matricula );

      setState(() {
        nome = colaboradorData['Nome'] ?? '';
        cpf = colaboradorData['CPF'] ?? '';
        rg = colaboradorData['RG'] ?? '';
        dataNascimento = colaboradorData['DataNascimento'] != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(colaboradorData['DataNascimento']))
            : '';
        dataAdmissao = colaboradorData['DataAdmissao'] != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(colaboradorData['DataAdmissao']))
            : '';
        ctps = colaboradorData['CTPS'] ?? '';
        matricula = colaboradorData['Matricula'] ?? '';
        cargo = colaboradorData['Cargo'] ?? '';
        nis = colaboradorData['NIS'] ?? '';

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
Future<Map<String, dynamic>> fetchColaborador(String cnpj, String matricula) async {
  // Monta a URL da requisição
  final url = Uri.parse("http://localhost:3000/colaboradores/$cnpj/$matricula");

  // Log da requisição feita
  print("Fazendo requisição para: $url");

  // Faz a requisição HTTP
  final response = await http.get(url);

  // Log do código de resposta (status code)
  print("Código de resposta: ${response.statusCode}");

  // Verifica o status code da resposta
  if (response.statusCode == 200) {
    // Decodifica o corpo da resposta
    final data = json.decode(response.body);

    // Log da imagem recebida (se existir)
    if (data['imagem'] != null && data['imagem'] is String) {
      print("Imagem recebida da API: ${data['imagem'].substring(0, 50)}...");
    }

    // Retorna os dados decodificados
    return data;
  } else if (response.statusCode == 404) {
    // Log de erro específico para colaborador não encontrado
    print("Erro: Colaborador não encontrado (404)");
    throw Exception('Colaborador não encontrado');
  } else {
    // Log de erro genérico
    print("Erro ao buscar colaborador. Status code: ${response.statusCode}");
    throw Exception('Erro ao buscar colaborador');
  }
}
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Color.fromARGB(255, 240, 240, 240),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        "Termos de Uso",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "1. INTRODUÇÃO\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                                text:
                                    "Este termo tem como objetivo informar ao usuário sobre a coleta, uso, armazenamento e proteção de seus dados pessoais e biométricos (imagem facial) pelo aplicativo Work-Time, em conformidade com a Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018 – LGPD).\n\n",
                                style: TextStyle()),
                            TextSpan(
                              text: "2. DADOS COLETADOS\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Ao utilizar o Work-Time, o usuário autoriza a coleta e o processamento de sua imagem facial para fins exclusivos de registro de ponto eletrônico e controle de acesso.\n\n",
                            ),
                            TextSpan(
                              text: "3. FINALIDADE DO TRATAMENTO DOS DADOS\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "- Identificação e autenticação do usuário no sistema de registro de ponto eletrônico;\n"
                                  "- Garantia da segurança e integridade das informações registradas;\n"
                                  "- Cumprimento de obrigações legais e regulatórias.\n\n",
                            ),
                            TextSpan(
                              text: "4. ARMAZENAMENTO E SEGURANÇA\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Os dados biométricos serão armazenados de forma segura, utilizando medidas técnicas e organizacionais adequadas para evitar acessos não autorizados, perdas ou vazamentos.\n\n",
                            ),
                            TextSpan(
                              text: "5. COMPARTILHAMENTO DOS DADOS\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Os dados coletados não serão compartilhados com terceiros, salvo por obrigação legal ou mediante autorização expressa do usuário.\n\n",
                            ),
                            TextSpan(
                              text: "6. DIREITOS DO USUÁRIO\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "- Acessar seus dados pessoais armazenados;\n"
                                  "- Solicitar a correção ou exclusão de seus dados;\n"
                                  "- Revogar este consentimento a qualquer momento, mediante solicitação formal.\n\n",
                            ),
                            TextSpan(
                              text: "7. CONSENTIMENTO\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Ao prosseguir com o uso do Work-Time, declaro estar ciente e de acordo com a coleta e o uso da minha imagem facial para os fins mencionados neste termo.\n",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Fechar",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 148, 177, 255),
        appBar: AppBar(
          title: Text("Perfil", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 30, 112, 243),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
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
                                children: [
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
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 5,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: _imagemBytes != null
                                                    ? Image.memory(
                                                        _imagemBytes!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/user.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
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
                                      Icon(
                                        Icons.emoji_people_rounded,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Nome: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          nome,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 21, 21, 21),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.today,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Data de Nascimento: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          dataNascimento,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.wallet_sharp,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("CPF: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          cpf,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.featured_play_list_sharp,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("RG: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          rg,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.view_timeline,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("CTPS: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          ctps,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.badge_rounded,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("NIS: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          nis,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Matricula: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          matricula,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.diversity_3_sharp,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Cargo: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          cargo,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: const Color.fromARGB(255, 29, 80, 163),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Data de Admissão: ",
                                          style: GoogleFonts.roboto(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Expanded(
                                        child: Text(
                                          dataAdmissao,
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description, color: Color.fromARGB(255, 0, 0, 0)),
                              const SizedBox(width: 8.0),
                              GestureDetector(
                                onTap: () => _showTermsDialog(context),
                                child: Text(
                                  "Termos de Uso",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
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