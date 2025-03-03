import 'dart:typed_data';
import 'dart:html'; // Necessário para o download
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FaceDetectionCameraScreen extends StatefulWidget {
  @override
  _FaceDetectionCameraScreenState createState() =>
      _FaceDetectionCameraScreenState();
}

class _FaceDetectionCameraScreenState extends State<FaceDetectionCameraScreen> {
  late CameraController _cameraController;
  List<CameraDescription> _cameras = [];
  Uint8List? _webImageBytes;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.max, // Usa a melhor resolução possível
        enableAudio: false,
      );
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Erro ao inicializar a câmera: $e");
    }
  }

  Future<void> _capturePhoto() async {
    if (!_cameraController.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Câmera não está inicializada.'),
      ));
      return;
    }

    if (kIsWeb) {
      await _handleWebCapture();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta funcionalidade é apenas para a web.'),
      ));
    }
  }

  Future<void> _handleWebCapture() async {
    try {
      final file = await _cameraController.takePicture();
      final bytes = await file.readAsBytes();

      setState(() {
        _webImageBytes = bytes;
      });

      _saveImageLocally(_webImageBytes!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao capturar a foto: $e'),
      ));
    }
  }

  void _saveImageLocally(Uint8List imageBytes) {
    final blob = Blob([imageBytes]);
    final url = Url.createObjectUrlFromBlob(blob);

    final anchor = AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'captured_image.jpg'
      ..click();

    Url.revokeObjectUrl(url);
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    if (_cameraController.value.isInitialized) {
      try {
        await _cameraController.dispose();
      } catch (e) {
        print("Erro ao liberar a câmera: $e");
      }
    }
  }

  Future<bool> _onWillPop() async {
    await _disposeCamera();
    return true; // Permite a navegação de volta
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Inserir ponto',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 30, 112, 243),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await _disposeCamera();
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: _isCameraInitialized
                    ? CameraPreview(_cameraController)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Inicializando câmera...",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
              ),

              // Botão centralizado na parte inferior
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 3, 33, 255),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: _capturePhoto,
                    child: Text(
                      'Registre',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}