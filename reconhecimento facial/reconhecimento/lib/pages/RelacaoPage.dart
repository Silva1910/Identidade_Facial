import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:reconhecimento/pages/CalendarPage.dart';
import 'package:reconhecimento/pages/AtualizarColaborador.dart';
import 'package:reconhecimento/pages/PerfilPage.dart';

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

 Future<void> fetchColaboradores() async {
    setState(() {
      loading = true; // Inicia o carregamento
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/colaboradores'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          colaboradores = data.map((item) => Colaborador.fromJson(item)).toList();
          loading = false; // Finaliza o carregamento
        });
      } else {
        throw Exception('Erro ao buscar colaboradores');
      }
    } catch (error) {
      setState(() {
        loading = false; // Finaliza o carregamento em caso de erro
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar colaboradores: $error')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    fetchColaboradores();
  }

  void _redirecionarPonto(BuildContext context, String matricula) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage(matricula: matricula)));
  }


  void _redirecionarPerfil(BuildContext context, String matricula, String cnpj) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilPage(matricula: matricula, cnpj: cnpj)));
  }

void _redirecionarCadastro(BuildContext context, String matricula, String cnpj) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AtualizarColaboradorpage(matricula: matricula, cnpj: cnpj),
    ),
  );
}

void _mostrarDialogoExclusao(BuildContext context, String matricula) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Excluir Colaborador"),
        content: Text("Deseja excluir o colaborador de matrícula $matricula?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final response = await http.delete(
                Uri.parse('http://localhost:3000/colaboradores/$matricula'),
              );

              if (response.statusCode == 200) {
                // Atualiza a lista de colaboradores após a exclusão
                await fetchColaboradores(); // Atualiza a lista
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Colaborador excluído com sucesso!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir colaborador')),
                );
              }

              Navigator.of(context).pop();
            },
            child: Text("Excluir", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}

void _mostrarDialogoResetSenha(BuildContext context, String matricula) {
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Resetar senha para matrícula: $matricula"),
            TextField(
              controller: novaSenhaController,
              decoration: InputDecoration(labelText: 'Nova senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmarSenhaController,
              decoration: InputDecoration(labelText: 'Repita a senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (novaSenhaController.text != confirmarSenhaController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('As senhas não coincidem!')),
                  );
                  return;
                }

                final response = await http.put(
                  Uri.parse('http://localhost:3000/colaboradores/$matricula/senha'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'senhaAtual': '', // Você pode precisar coletar a senha atual também
                    'novaSenha': novaSenhaController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Senha atualizada com sucesso!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar senha')),
                  );
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      );
    },
  );
}

  Widget buildPopupMenu(BuildContext context, String matricula, String cnpj) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'excluir') {
          _mostrarDialogoExclusao(context, matricula);
        } else if (value == 'reset_de_senha') {
          _mostrarDialogoResetSenha(context, matricula);
        } else if (value == 'Relacao_Ponto') {
          _redirecionarPonto(context, matricula);
        } else if (value == 'Alterar_Dados') {
          _redirecionarCadastro(context, matricula, cnpj);
        }else if (value == 'Perfil_Colaborador') {
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
