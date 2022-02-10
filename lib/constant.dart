import 'package:flutter/material.dart';

const baseURL = 'http://192.168.1.5:8000/api';
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
