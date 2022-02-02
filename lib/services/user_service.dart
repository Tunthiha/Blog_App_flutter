import 'dart:convert';
import 'dart:io';

import 'package:flutter_api_test/constant.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});
    switch (response.statusCode) {
      case 200:
        apiresponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiresponse.error = somethingWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }
  return apiresponse;
}

Future<ApiResponse> register(
    String email, String password, String name, String conPasswowrd) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': conPasswowrd
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiresponse.error = somethingWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }
  return apiresponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiresponse.error = unauthorized;
        break;
      default:
        apiresponse.error = somethingWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }
  return apiresponse;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.clear();
}

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
