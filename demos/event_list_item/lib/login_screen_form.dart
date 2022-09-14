import 'package:flutter/material.dart';

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
        title: const Text('Login with Form'),
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
      } catch (e) {
        error = e.toString();
      }
    }
  }

  Future<void> _login(String email, String password) async {
    print('Logged in using: $email:$password');
    if (email == '' && password == '') {
      print('Success!!');
    } else {
      throw 'Verkeerd email / password combinatie';
    }
  }
}

class LoginFormData {
  String email = '';
  String password = '';
}
