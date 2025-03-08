import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reconhecimento/utils/termosUso.dart';
import 'package:reconhecimento/service/colaboradorService.dart';

class PerfilPage extends StatefulWidget {
  final String matricula;
  final String cnpj;
  const PerfilPage({required this.matricula, required this.cnpj});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  
  final TermosUso termosUso = TermosUso();
  
  Map<String, dynamic> colaboradorData =
      {}; // Map para armazenar os dados do colaborador
  Uint8List? _imagemBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosColaborador();
  }



  Future<void> _carregarDadosColaborador() async {
    try {
       final colaboradorService = ColaboradorService('http://localhost:3000');
      final data =  await colaboradorService.buscarColaborador(widget.cnpj, widget.matricula);

      setState(() {
        colaboradorData = data;

        if (data['imagem'] != null && data['imagem'] is String) {
          _imagemBytes = base64Decode(data['imagem']);
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 218, 255),
      appBar: AppBar(
        title: const Text(
          'Perfil do Colaborador',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), // Cor branca
          ),
        ),
        centerTitle: true,
        backgroundColor:
            const Color.fromARGB(255, 29, 80, 163), // Cor de fundo do AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto do colaborador (em um ClipOval com contorno)
            if (_imagemBytes != null)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 29, 80, 163),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.memory(
                    _imagemBytes!,
                    width: 200, // Tamanho aumentado
                    height: 200, // Tamanho aumentado
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Card para informações pessoais
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow("Nome : ", colaboradorData['Nome']),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        "Data de Nascimento : ",
                        colaboradorData['DataNascimento'] != null
                            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                colaboradorData['DataNascimento']))
                            : ''),
                    const SizedBox(height: 12),
                    _buildInfoRow("CPF : ", colaboradorData['CPF']),
                    const SizedBox(height: 12),
                    _buildInfoRow("RG : ", colaboradorData['RG']),
                    const SizedBox(height: 12),
                    _buildInfoRow("CTPS : ", colaboradorData['CTPS']),
                    const SizedBox(height: 12),
                    _buildInfoRow("NIS : ", colaboradorData['NIS']),
                  ],
                ),
              ),
            ),

            // Card para informações profissionais
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow("Matrícula : ", colaboradorData['Matricula']),
                    const SizedBox(height: 12),
                    _buildInfoRow("Cargo : ", colaboradorData['Cargo']),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        "Data de Admissão : ",
                        colaboradorData['DataAdmissao'] != null
                            ? DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(colaboradorData['DataAdmissao']))
                            : ''),
                  ],
                ),
              ),
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
                      color:
                          const Color.fromARGB(255, 0, 22, 57).withOpacity(0.8),
                      offset: const Offset(0, 6),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => termosUso.showTermsDialog(context),
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _getIconForLabel(label),
                color: const Color.fromARGB(255, 29, 80, 163),
                size: 20.0,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 21, 21, 21),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case "Nome : ":
        return Icons.emoji_people_rounded;
      case "Data de Nascimento : ":
        return Icons.today;
      case "CPF : ":
        return Icons.wallet_sharp;
      case "RG : ":
        return Icons.featured_play_list_sharp;
      case "CTPS : ":
        return Icons.view_timeline;
      case "NIS : ":
        return Icons.badge_rounded;
      case "Matrícula : ":
        return Icons.receipt;
      case "Cargo : ":
        return Icons.diversity_3_sharp;
      case "Data de Admissão : ":
        return Icons.calendar_today_outlined;
      default:
        return Icons.info;
    }
  }
}
