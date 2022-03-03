import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api_test/constant.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/screens/home.dart';
import 'package:flutter_api_test/screens/post_screen.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool _loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  Future getimage() async {
    final PickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        _imageFile = File(PickedFile.path);
      });
    }
  }

  retreiveUserDetail() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        _loading = _loading ? !_loading : _loading;
        txtNameController.text = user!.name ?? '';

        //print(user.name);
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    }
  }

  void updateProfile() async {
    ApiResponse response = await updateUser(txtNameController.text);
    setState(() {
      _loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retreiveUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Screen",
          style: robotoTextstyle(),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(top: 40, left: 40, right: 40),
              child: ListView(
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: kinputDecoration('Name'),
                      controller: txtNameController,
                      validator: (value) =>
                          value!.isEmpty ? 'invalid Name' : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  kTextbutton('Update', () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      updateProfile();
                    }
                  })
                ],
              ),
            ),
      drawer: SafeArea(
          child: Navigation(
        user: user,
        selectedNav: 2,
      )),
    );
  }
}
