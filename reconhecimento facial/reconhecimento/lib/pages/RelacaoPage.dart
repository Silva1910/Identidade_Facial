
import 'package:flutter/material.dart';
import 'package:reconhecimento/pages/CalendarPage.dart';
import 'package:reconhecimento/pages/AtualizarColaborador.dart';
import 'package:reconhecimento/pages/PerfilPage.dart';
import 'package:reconhecimento/utils/dialogos.dart';
import 'package:reconhecimento/service/colaboradorService.dart';


class Colaborador {
  final String nome;
  final String matricula;
  final int cargaHoraria;
  final double saldoHoras;
   final String cnpj;
  Colaborador({
    required this.nome,
    required this.matricula,
    required this.cargaHoraria,
    required this.saldoHoras,
   required this.cnpj, 
  });

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
      nome: json['Nome'],
      matricula: json['Matricula'],
      cargaHoraria: json['CargaHoraria'],
      saldoHoras: json['saldoHoras'].toDouble(),
       cnpj: json['CNPJ'],
    );
  }
}

class RelacaoPage extends StatefulWidget {
    final String cnpj;
  
  const RelacaoPage({required this.cnpj});
  @override
  _RelacaoPageState createState() => _RelacaoPageState();
}
class _RelacaoPageState extends State<RelacaoPage> {
  List<Colaborador> colaboradores = [];
  bool loading = true;
  final Dialogos dialogos = Dialogos();
  final ColaboradorService colaboradorService = ColaboradorService('http://localhost:3000');

  @override
  void initState() {
    super.initState();
    _carregarColaboradores();
  }

  Widget buildPopupMenu(BuildContext context, String matricula, String cnpj) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'excluir') {
           dialogos.mostrarDialogoExclusao(context, matricula, cnpj, _carregarColaboradores); 
        } else if (value == 'reset_de_senha') {
          dialogos.mostrarDialogoAtualizarSenha(context, matricula);
        } else if (value == 'Relacao_Ponto') {
          _redirecionarPonto(context, matricula);
        } else if (value == 'Alterar_Dados') {
          _redirecionarAtualizar(context, matricula, cnpj);
        } else if (value == 'Perfil_Colaborador') {
          _redirecionarPerfil(context, matricula, cnpj);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(value: 'excluir', child: Text("Excluir Colaborador")),
          PopupMenuItem(value: 'reset_de_senha', child: Text("Configurar nova senha")),
          PopupMenuItem(value: 'Relacao_Ponto', child: Text("Relação de ponto")),
          PopupMenuItem(value: 'Alterar_Dados', child: Text("Alterar dados")),
          PopupMenuItem(value: 'Perfil_Colaborador', child: Text("Perfil do colaborador")),
        ];
      },
    );
  }

  Future<void> _carregarColaboradores() async {
    try {
      List<Map<String, dynamic>> dadosColaboradores = await colaboradorService.buscarTodosColaboradores();
      setState(() {
        colaboradores = dadosColaboradores.map((json) => Colaborador.fromJson(json)).toList();
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      // Exibir uma mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar colaboradores: $e')),
      );
    }
  }


  void _redirecionarPonto(BuildContext context, String matricula) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage(matricula: matricula)));
  }

  void _redirecionarPerfil(BuildContext context, String matricula, String cnpj) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilPage(matricula: matricula, cnpj: cnpj)));
  }

  Future<void> _redirecionarAtualizar(BuildContext context, String matricula, String cnpj) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AtualizarColaboradorpage(matricula: matricula, cnpj: cnpj),
    ),
  );
  _carregarColaboradores();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 178, 205, 220),
      appBar: AppBar(
        title: Text("Relação de colaboradores ", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 30, 112, 243),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator()) // Exibe o loading
          : colaboradores.isEmpty
              ? Center(
                  child: Text(
                    "Nenhum colaborador cadastrado ainda.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: colaboradores.length,
                  itemBuilder: (context, index) {
                    final colaborador = colaboradores[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text("Nome: ${colaborador.nome}"),
                        subtitle: Text("Matrícula: ${colaborador.matricula}\nSaldo de Horas: ${colaborador.saldoHoras.toStringAsFixed(2)} horas"),
                        trailing: buildPopupMenu(context, colaborador.matricula, colaborador.cnpj),
                      ),
                    );
                  },
                ),
    );
  }
}