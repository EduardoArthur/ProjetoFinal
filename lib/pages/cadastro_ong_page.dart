import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/pages/ong_home_page.dart';
import 'package:tcc/services/ong_service.dart';

import '../services/auth_service.dart';

class CadastroOngPage extends StatefulWidget {
  @override
  _CadastroOngPageState createState() => _CadastroOngPageState();
}

class _CadastroOngPageState extends State<CadastroOngPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  OngService ongService = OngService();
  bool _isLoading = false;

  Future<void> _cadastrarOng() async {
    setState(() {
      _isLoading = true;
    });

    String nome = _nomeController.text;
    String cnpj = _cnpjController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    try {
      await context.read<AuthService>().registrar(email, senha);

      AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.usuario?.updateDisplayName(nome);
      await ongService.createOng(nome, cnpj, auth.usuario!);

      if(!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OngHomePage()),
      );

    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de ONG'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da ONG',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _cnpjController,
                decoration: InputDecoration(
                  labelText: 'CNPJ',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _cadastrarOng,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Cadastrar ONG'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

