// lib/utils/image_utils.dart
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:image/image.dart' as img;

class ImageUtils {
  static Future<File?> comprimirImagem(File file) async {
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
  
Future<File> compressImage(File file) async {
  final image = img.decodeImage(await file.readAsBytes());
  final resized = img.copyResize(image!, width: 800); // Redimensiona para 800px
  final compressed = File(file.path)
    ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));
  return compressed;
}
}