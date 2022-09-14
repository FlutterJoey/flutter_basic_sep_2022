import 'dart:convert';

import 'package:event_list_item/generate_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final LoginFormData _data = LoginFormData();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(preferences.getString('key') ?? 'test'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _createEmailInput(),
                  const SizedBox(
                    height: 16,
                  ),
                  _createPasswordInput(),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _createPasswordInput() {
    return TextFormField(
      decoration: const InputDecoration(
        label: Text('Password'),
      ),
      validator: _validateRequired,
      onSaved: (value) {
        _data.password = value!;
      },
    );
  }

  TextFormField _createEmailInput() {
    return TextFormField(
      decoration: const InputDecoration(
        label: Text('Email'),
      ),
      validator: _validateRequired,
      onSaved: (value) {
        _data.email = value!;
      },
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _submit() async {
    var form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      try {
        await _login(_data.email, _data.password);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const GenerateScreen();
              },
            ),
          );
        }
      } catch (e) {
        error = e.toString();
      }
    }
  }

  Future<void> _login(String email, String password) async {
    var response = await _loginToApi(email, password);
    if (response.statusCode == 200) {
      await preferences.setString(
        'api-key',
        jsonDecode(response.body)['token'],
      );
    } else {
      throw 'Verkeerd email / password combinatie';
    }
  }

  Future<Response> _loginToApi(String email, String password) {
    return post(
      Uri.parse(
        'https://a806-185-10-158-5.ngrok.io/login',
      ),
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );
  }
}

class LoginFormData {
  String email = '';
  String password = '';
}
