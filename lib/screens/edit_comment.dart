import 'package:flutter/material.dart';
import 'package:flutter_api_test/constant.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/comment.dart';
import 'package:flutter_api_test/services/comment_service.dart';
import 'package:flutter_api_test/services/user_service.dart';

import 'login.dart';

class EditComment extends StatefulWidget {
  final Comment comment;
  const EditComment({Key? key, required this.comment}) : super(key: key);

  @override
  _EditCommentState createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  TextEditingController _txtCommentController = TextEditingController();
  bool _loading = true;

  void _editComment() async {
    ApiResponse response =
        await editComment(_txtCommentController.text, widget.comment.id ?? 0);
    if (response.error == null) {
      Navigator.pop(context);
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
    _txtCommentController.text = widget.comment.comment.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Comment',
          style: robotoTextstyle(),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26))),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: kinputDecoration('Comment'),
                controller: _txtCommentController,
              ),
            ),
            IconButton(
                onPressed: () {
                  if (_txtCommentController.text.isNotEmpty) {
                    setState(() {
                      _loading = true;
                    });
                    _editComment();
                  }
                  FocusScope.of(context).unfocus();
                },
                icon: Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
