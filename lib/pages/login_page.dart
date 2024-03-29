import 'package:PetResgate/widgets/pop_ups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/cadastro_ong_page.dart';
import '../pages/ong_home_page.dart';
import '../pages/report_lost_animal_page.dart';
import '../pages/home_page.dart';
import '../services/ong_service.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final ongService = OngService();
  final popUps = PopUps();

  bool isLogin = true;
  bool rememberMe = false;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;
  final String loginAnonimo = "Reportar Anonimamente";
  final String loginOng = "Cadastrar ONG";

  @override
  void initState() {
    super.initState();
    setFormAction(true);
    popUps.showStartPopup(context);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      AuthService auth = context.read<AuthService>();

      await auth.login(email.text, senha.text);

      checkOngExists(auth.usuario!);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (!context.mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> checkOngExists(User user) async {
    bool ongExists = user.displayName != null;

    if (!context.mounted) return;

    if (ongExists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ONG home
          builder: (context) => OngHomePage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  registrar() async {
    setState(() => loading = true);
    try {
      AuthService auth = context.read<AuthService>();
      await auth.registrar(email.text, senha.text);
      checkOngExists(auth.usuario!);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showTitle(),
                emailController(),
                passwordController(),
                loginButtonController(),
                registerButton(),
                botaoDenunciaAnonima(),
                registerOngButton(),
                // rememberMeCheckBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showTitle(){
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        letterSpacing: -1.5,
      ),
    );
  }

  Widget emailController(){
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TextFormField(
        controller: email,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Informe o email corretamente!';
          }
          return null;
        },
      ),
    );
  }

  Widget passwordController(){
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: TextFormField(
        controller: senha,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Senha',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Informa sua senha!';
          } else if (value.length < 6) {
            return 'Sua senha deve ter no mínimo 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget loginButtonController(){
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (isLogin) {
              login();
            } else {
              registrar();
            }
          }
        },
        child: loginButton(),
      ),
    );
  }

  Widget loginButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (loading)
          ? [
        const Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        )
      ]
          : [
        const Icon(Icons.check),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            actionButton,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget registerButton(){
    return TextButton(
      onPressed: () => setFormAction(!isLogin),
      child: Text(toggleButton),
    );
  }

  Widget botaoDenunciaAnonima(){
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportLostAnimalPage(),
          ),
        );
      },
      child: Text(loginAnonimo),
    );
  }

  Widget registerOngButton(){
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CadastroOngPage(),
          ),
        );
      },
      child: Text(loginOng),
    );
  }

  Widget rememberMeCheckBox(){
    return CheckboxListTile(
      title: const Text("Lembrar de Mim"),
      value: rememberMe,
      onChanged: (value) {
        setState(() {
          rememberMe = value!;
        });
      },
    );
  }

}