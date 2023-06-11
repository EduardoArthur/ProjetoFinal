import 'package:flutter/material.dart';

import '../domain/enumeration/AnimalKind.dart';

class ReportDialog extends StatefulWidget {
  final Function(AnimalKind?, String) onSubmit;
  final VoidCallback onCancel;

  ReportDialog({required this.onSubmit, required this.onCancel});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  AnimalKind? selectedAnimalKind;
  String description = '';

  final _formKey = GlobalKey<FormState>();

  void submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Call the callback function provided by the MapService
      widget.onSubmit(selectedAnimalKind, description);

      // Reset the form after submission if needed
      _formKey.currentState?.reset();
    }
  }

  String animalKindToString(AnimalKind animalKind) {
    return animalKind.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      right: 16.0,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<AnimalKind>(
                  value: selectedAnimalKind,
                  onChanged: (value) {
                    setState(() {
                      selectedAnimalKind = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Animal',
                  ),
                  items: AnimalKind.values.map((animalKind) {
                    return DropdownMenuItem<AnimalKind>(
                      value: animalKind,
                      child: Text(animalKindToString(animalKind)),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione um tipo de animal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'De uma breve descrição da situação';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text('Enviar'),
                    ),
                    ElevatedButton(
                      onPressed: widget.onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}