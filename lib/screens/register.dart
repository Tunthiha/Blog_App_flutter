import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/screens/post_screen.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController paswordConfirmController = TextEditingController();
  bool loading = false;
  void _registerUser() async {
    ApiResponse response = await register(
        emailController.text,
        passwordController.text,
        nameController.text,
        paswordConfirmController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
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
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: OpenSansCondensedTextStyle(),
        ),
        centerTitle: true,
      ),
      body: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: (value) => value!.isEmpty ? 'Invalid name' : null,
                decoration: kinputDecoration("Name"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) => value!.isEmpty ? 'Invalid email' : null,
                decoration: kinputDecoration("Email"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Required at least 6' : null,
                decoration: kinputDecoration("Password"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: paswordConfirmController,
                validator: (value) => value != passwordController.text
                    ? 'Password does not match'
                    : null,
                decoration: kinputDecoration("Confirm Password"),
              ),
              SizedBox(
                height: 10,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : kTextbutton('Register', () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    }),
              SizedBox(
                height: 10,
              ),
              kLoginRegisterHint('Already have Account?', 'Login', () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              })
            ],
          )),
    );
  }
}
