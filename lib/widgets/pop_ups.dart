import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopUps {
  static const mensagemBoasVindas =
      "Este aplicativo foi desenvolvido por um aluno de ciência da computação como trabalho de conclusão de curso pela UERJ. \nSeu objetivo é que os usuários possam marcar em um mapa a localização do animal encontrado, junto com uma breve descrição e opcionalmente uma foto. \nAs ONGs têm acesso a todas as denúncias em aberto já feitas, por ordem de proximidade.As mesmas podem ser marcadas como resolvidas após o resgate ser concluído.";

  static const instrucoesMapa =
      'Use os dedos para mexer no mapa.\nAperte no mapa para marcar a localização e depois clique no botão Reportar no topo da tela';

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
                title: const Text("Bem-Vindo"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(mensagemBoasVindas),
                      CheckboxListTile(
                        title: const Text("Não exibir novamente"),
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
                        child: const Text("Fechar"),
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
                      title: const Text("Não exibir novamente"),
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
                      child: const Text("Fechar"),
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
}
