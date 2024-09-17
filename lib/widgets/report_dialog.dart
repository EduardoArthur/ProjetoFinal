import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/enumeration/AnimalKind.dart';

class ReportDialog extends StatefulWidget {
  final Function(AnimalKind?, String, String) onSubmit;
  final VoidCallback onCancel;

  ReportDialog({required this.onSubmit, required this.onCancel});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  AnimalKind? selectedAnimalKind;
  String description = '';
  String imageUrl = '';

  final _formKey = GlobalKey<FormState>();

  void submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Call the callback function provided by the MapService
      widget.onSubmit(selectedAnimalKind, description, imageUrl);

      // Reset the form after submission if needed
      _formKey.currentState?.reset();
    }
  }

// =============================================================================
//                                  Build
// =============================================================================

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
                animalKindDropdownField(),
                const SizedBox(height: 16.0),
                descriptionFormField(),
                const SizedBox(height: 16.0),
                uploadPhotoButton(),
                const SizedBox(height: 16.0),
                submitFormRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// =============================================================================
//                              Form Fields
// =============================================================================

  Widget animalKindDropdownField(){
    return DropdownButtonFormField<AnimalKind>(
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
          child: Text(animalKind.name),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Selecione um tipo de animal';
        }
        return null;
      },
    );
  }

  Widget descriptionFormField(){
    return TextFormField(
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
    );
  }

  Widget uploadPhotoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Anexar Foto'),
        ),
        if(imageUrl.isNotEmpty)
          Image.file(File(imageUrl), width: 50, height: 50),
      ],
    );
  }

// =============================================================================
//                        Submit and Cancel buttons
// =============================================================================

  Widget submitFormRow(){
    return Row(
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
    );
  }

  Future<void> _pickImage() async {
    if ( await Permission.photos.request().isGranted == false &&
         await Permission.storage.request().isGranted == false ) {
      print("Permissão negada.");
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }



}