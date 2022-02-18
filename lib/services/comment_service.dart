import 'dart:convert';

import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/comment.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

Future<ApiResponse> getComments(int id) async {
  ApiResponse apiresponse = ApiResponse();
  //String? searchUrl = "$postURL?search=$query";
  //print(SearchUrl);
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(
        postURL + "/${id}/comments",
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['comments']
            .map((c) => Comment.fromJson(c))
            .toList();
        apiresponse.data as List<dynamic>;
        //print(apiresponse.data);
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

Future<ApiResponse> createComment(int postId, String? comment) async {
  //print(body);
  //print(image);
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse("$postURL/$postId/comments"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'comment': comment,
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body);
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

Future<ApiResponse> deleteComment(int commentId) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$commentURL/$commentId'),
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

Future<ApiResponse> editComment(String comment, int commentId) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.put(Uri.parse('$commentURL/$commentId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'comment': comment,
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
        //print(response.body);
        break;
      // case 422:
      //   final errors = jsonDecode(response.body)['errors'];
      //   apiresponse.error = errors[errors.keys.elementAt(0)][0];
      //   break;
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
