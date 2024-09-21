import 'package:PetResgate/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../pages/login_page.dart';

class PopUps extends ChangeNotifier {
// =============================================================================
//                               Constants
// =============================================================================

  // Fonts
  static const fontSize = 18.0;
  static const fontWeight = FontWeight.bold;
  static const labelColor = Colors.white;

  // Buttons
  static const borderRadius = 8.0;
  static const iconSize = 24.0;
  static const verticalPadding = 16.0;
  static const horizontalPadding = 32.0;

  // Space between buttons
  static const sizedBoxHeight = 24.0;

  // labels
  static const welcomeLabel = "Bem-Vindo";
  static const dontShowUpLabel = "Não exibir novamente";
  static const closeLabel = "Fechar";
  static const cancelLabel = "Cancelar";

  static const deleteWarningHeaderLabel = "Confirmação de Exclusão";

  static const deleteWarningBodyLabel =
      "Você tem certeza que deseja excluir sua conta? Esta ação é irreversível.";

  static const mensagemBoasVindas =
      "Este aplicativo foi desenvolvido por um aluno de ciência da computação como trabalho de conclusão de curso pela UERJ. \nSeu objetivo é que os usuários possam marcar em um mapa a localização do animal encontrado, junto com uma breve descrição e opcionalmente uma foto. \nAs ONGs têm acesso a todos os casos em aberto já feitos, por ordem de proximidade.As mesmas podem ser marcadas como resolvidas após o resgate ser concluído.";

  static const instrucoesMapa =
      'Use os dedos para mexer no mapa.\nAperte no mapa para marcar a localização e depois clique no botão Reportar no topo da tela';

// =============================================================================
//                              Welcome Page
// =============================================================================

  Future<void> showStartPopup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showPopup = prefs.getBool('showPopup') ?? true;

    if (showPopup) {
      bool doNotShowAgain = false;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text(welcomeLabel),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(mensagemBoasVindas),
                      CheckboxListTile(
                        title: const Text(dontShowUpLabel),
                        value: doNotShowAgain,
                        onChanged: (bool? value) {
                          setState(() {
                            doNotShowAgain = value!;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (doNotShowAgain) {
                            await prefs.setBool('showPopup', false);
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(closeLabel,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

// =============================================================================
//                              Map Instructions
// =============================================================================

  Future<void> showMapInstructions(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool shouldShowPopup = prefs.getBool('showMapInstructions') ?? true;

    if (shouldShowPopup) {
      bool doNotShowAgain = false;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text("Instruções do mapa interativo"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(instrucoesMapa),
                    CheckboxListTile(
                      title: const Text(dontShowUpLabel),
                      value: doNotShowAgain,
                      onChanged: (bool? value) {
                        setState(() {
                          doNotShowAgain = value!;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (doNotShowAgain) {
                          await prefs.setBool('showMapInstructions', false);
                        }
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(closeLabel,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

// =============================================================================
//                              Delete User
// =============================================================================

  Future<void> deleteAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: warningHeader(context),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  deleteWarningBodyLabel,
                  style: TextStyle(color: Colors.white), // Texto em branco
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(bottom: verticalPadding), // Ajuste no padding inferior
          actions: [
            deleteButtons(context),
          ],
        );
      },
    );
  }

  Widget warningHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text(
              deleteWarningHeaderLabel,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close, color: Colors.white), // Ícone de X
        )
      ],
    );
  }

  Widget deleteButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sizedBoxHeight), // Espaçamento para centralizar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Maior distância entre botões
        children: [
          cancelButton(context),
          removeUserButton(context),
        ],
      ),
    );
  }

// =============================================================================
//                              Widgets
// =============================================================================

  Widget cancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop(); // Fecha o diálogo
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey, // Cor mais neutra para cancelar
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordas arredondadas
        ),
      ),
      child: const Text(
        cancelLabel,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget removeUserButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        removeUserAndReturnToLoginPage(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Cor do botão de exclusão
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: const Text(
        "Confirmar exclusão",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

// =============================================================================
//                              Functions
// =============================================================================

  Future<void> removeUserAndReturnToLoginPage(BuildContext context) async {
    await context.read<AuthService>().deleteUser();

    // Evita warning de async entre blocos de contexto
    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop(); // Fecha o diálogo

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
    );
  }
}
