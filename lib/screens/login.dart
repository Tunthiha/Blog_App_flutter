import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/screens/post_screen.dart';
import 'package:flutter_api_test/screens/register.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    //print(user);
    setState(() {
      loading = false;
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: robotoTextstyle(),
        ),
        centerTitle: true,
      ),
      body: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (value) => value!.isEmpty ? 'Invalid email' : null,
                decoration: kinputDecoration("Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Required at least 6' : null,
                decoration: kinputDecoration("Password"),
              ),
              const SizedBox(
                height: 10,
              ),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : kTextbutton('Login', () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _loginUser();
                        });
                      }
                    }),
              const SizedBox(
                height: 10,
              ),
              kLoginRegisterHint('Reigister?', 'Register', () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Register()),
                    (route) => false);
              })
            ],
          )),
    );
  }
}
