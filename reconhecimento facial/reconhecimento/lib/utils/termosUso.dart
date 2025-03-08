import 'package:flutter/material.dart';
class TermosUso{


  void showTermsDialog(BuildContext context) {
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
  }