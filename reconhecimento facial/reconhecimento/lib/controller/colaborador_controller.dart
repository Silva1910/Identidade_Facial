import 'package:flutter/material.dart';
import 'package:reconhecimento/service/colaboradorService.dart';
import 'dart:typed_data'; 
class ColaboradorController {
  final ColaboradorService _service;

  ColaboradorController(this._service);

  Future<void> atualizarColaborador({
    required String cnpj,
    required String matricula,
    required Map<String, String> campos,
    required Uint8List? imagemBytes,
    required BuildContext context,
  }) async {
    try {
      await _service.atualizarColaborador(
        cnpj: cnpj,
        matricula: matricula,
        campos: campos,
        imagemBytes: imagemBytes,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Colaborador atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar colaborador: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> buscarColaborador(String cnpj, String matricula) async {
    return await _service.buscarColaborador(cnpj, matricula);
  }
}