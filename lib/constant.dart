import 'package:flutter/material.dart';
import 'package:flutter_api_test/screens/bookmark_screen.dart';
import 'package:flutter_api_test/screens/home.dart';
import 'package:flutter_api_test/screens/login.dart';
import 'package:flutter_api_test/screens/profile_screen.dart';
import 'package:flutter_api_test/services/user_service.dart';

import 'models/user.dart';

const baseURL = 'http://192.168.1.4:8000/api';

const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postURL = baseURL + '/posts';
const commentURL = baseURL + '/comments';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWrong = 'Something went wrong';

TextStyle OpenSansCondensedTextStyle() =>
    const TextStyle(fontFamily: 'OpenSansCondensed', color: Colors.black);
TextStyle robotoTextstyle() =>
    const TextStyle(fontFamily: 'Roboto', color: Colors.white);
InputDecoration kinputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

TextButton kTextbutton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => const Color(0xFF11468F)),
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(vertical: 10))),
  );
}

//loginreigister

Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: const TextStyle(color: Colors.blue),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}

class Navigation extends StatelessWidget {
  const Navigation({
    Key? key,
    required this.selectedNav,
    required this.user,
  }) : super(key: key);

  final User? user;
  final int selectedNav;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF3f37cc),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: AssetImage('images/blog.jpg'))),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: Text(
                      "Hello ${user?.name ?? ''}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )),
          Card(
            color: selectedNav == 1 ? Color(0xFF5C54E9) : Color(0xFF3f37cc),
            elevation: selectedNav == 1 ? 10 : 1,
            child: ListTile(
              leading: const Icon(
                Icons.document_scanner_sharp,
                color: Colors.white,
              ),
              title: const Text("Home", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );

                //Navigator.pop(context);
              },
            ),
          ),
          Card(
            color: selectedNav == 2 ? Color(0xFF5C54E9) : Color(0xFF3f37cc),
            elevation: selectedNav == 2 ? 10 : 1,
            child: ListTile(
              leading: const Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              title:
                  const Text("Profile", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );

                //Navigator.pop(context);
              },
            ),
          ),
          Card(
            color: selectedNav == 3 ? Color(0xFF5C54E9) : Color(0xFF3f37cc),
            elevation: selectedNav == 3 ? 10 : 1,
            child: ListTile(
              leading: const Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              title: const Text(
                "Book Marked Posts",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookMark()),
                );

                //Navigator.pop(context);
              },
            ),
          ),
          Card(
            color: const Color(0xFF3f37cc),
            elevation: 1,
            child: ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              title:
                  const Text("Log Out", style: TextStyle(color: Colors.white)),
              onTap: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false)
                    });
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text("${user?.email}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
