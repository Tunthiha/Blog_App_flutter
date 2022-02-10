import 'dart:convert';

import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

Future<ApiResponse> getPosts(String? query) async {
  ApiResponse apiresponse = ApiResponse();
  String? searchUrl = "$postURL?search=$query";
  //print(SearchUrl);
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(
        searchUrl,
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['posts']
            .map((p) => Post.fromJson(p))
            .toList();
        apiresponse.data as List<dynamic>;
        //print(apiresponse.data);
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

Future<ApiResponse> createPost(String body, String? image) async {
  //print(body);
  //print(image);
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(postURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: image != null
            ? {
                'body': body,
                'image': image,
              }
            : {'body': body});
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> editPost(String body, int postId, String? image) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$postURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: image != null
            ? {
                'body': body,
                'image': image,
              }
            : {'body': body});
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body);
        print(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiresponse.error = unauthorized;
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

Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$postURL/$postId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiresponse.error = unauthorized;
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
