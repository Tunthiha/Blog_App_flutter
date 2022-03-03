import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/models/post_data.dart';
import 'package:flutter_api_test/screens/home.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import 'login.dart';

class EditPost extends StatefulWidget {
  final Post post;

  const EditPost({Key? key, required this.post}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtConfrollerBody = TextEditingController();

  bool _loading = false;
  File? _imageFile;
  dynamic img;

  final _picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _editPost(int postId) async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await editPost(
      _txtConfrollerBody.text,
      postId,
      image,
    );

    if (response.error == null) {
      // ---- Provider -----
      //Provider.of<PostData>(context, listen: false).retrievePs();
      //Provider.of<PostData>(context, listen: false).updatepost();
      //Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false);
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    //final _postID = widget.post.id;
    _txtConfrollerBody.text = widget.post.body.toString();
    if (widget.post.image != null) {
      //wdiget.post.image
      //print(widget.post.image);
      img = NetworkImage('${widget.post.image}');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Post",
            style: robotoTextstyle(),
          ),
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        image: _imageFile == null
                            ? DecorationImage(
                                image: img ??
                                    NetworkImage(
                                        'https://picsum.photos/250?image=9'),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: FileImage(_imageFile ?? File('')))),
                    child: Center(
                        child: IconButton(
                      onPressed: () {
                        getImage();
                      },
                      icon: const Icon(Icons.image),
                      iconSize: 50,
                      color:
                          _imageFile == null ? Colors.black12 : Colors.black12,
                    )),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _txtConfrollerBody,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        validator: (val) =>
                            val!.isEmpty ? 'Post cannot be empty' : null,
                        decoration: const InputDecoration(
                          hintText: "Context here",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black45)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: kTextbutton("Update Post", () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = !_loading;
                        });
                        _editPost(widget.post.id ?? 0);
                      }
                    }),
                  )
                ],
              ));
  }
}
