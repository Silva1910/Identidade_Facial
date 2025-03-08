import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:reconhecimento/service/colaboradorService.dart';


class Dialogos {

void mostrarDialogoAtualizarSenha(BuildContext context, String matricula) {
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


  Future<String?> mostrarDialogoCadastroSenha(BuildContext context) async {
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
                      Navigator.pop(
                          context, senhaController.text); // Retorna a senha
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




void mostrarDialogoExclusao(BuildContext context, String matricula, String cnpj, Function recarregarColaboradores) {
  final ColaboradorService colaboradorService = ColaboradorService('http://localhost:3000');
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
                // Chama a função para recarregar os colaboradores
                await recarregarColaboradores();
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
}