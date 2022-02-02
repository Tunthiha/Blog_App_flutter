import 'package:flutter/material.dart';

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
    TextStyle(fontFamily: 'OpenSansCondensed');
InputDecoration kinputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

TextButton kTextbutton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Color(0xFFFF4040)),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
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
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}
