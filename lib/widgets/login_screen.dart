import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _loginWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final auth = FirebaseAuth.instance;
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to the map screen or desired screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));
      } catch (e) {
        // Handle login error
        print('Login Error: $e');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Login Error'),
            content: Text('An error occurred during login. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final auth = FirebaseAuth.instance;
      await auth.signInAnonymously();

      // Navigate to the map screen or desired screen
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));
    } catch (e) {
      // Handle anonymous login error
      print('Anonymous Login Error: $e');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Anonymous Login Error'),
          content: Text('An error occurred during anonymous login. Please try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _loginWithEmailAndPassword,
                child: _isLoading ? CircularProgressIndicator() : Text('Login'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: _isLoading ? null : _loginAnonymously,
                child: Text('Login Anonymously'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}