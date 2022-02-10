import 'package:flutter/material.dart';
import 'package:flutter_api_test/constant.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/screens/home.dart';
import 'package:flutter_api_test/screens/post_screen.dart';
import 'package:flutter_api_test/services/user_service.dart';

import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool _loading = true;
  retreiveUserDetail() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        _loading = _loading ? !_loading : _loading;

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
      body: Container(
        child: const Text("this is profile"),
      ),
      endDrawer: SafeArea(
        child: Drawer(
          backgroundColor: Color(0xFF3f37cc),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('images/blog.jpg'))),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 12,
                        left: 16,
                        child: Text(
                          "Hello ${user?.name ?? ''}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )),
              Card(
                color: Color(0xFF3f37cc),
                elevation: 1,
                child: ListTile(
                  leading: Icon(
                    Icons.document_scanner_sharp,
                    color: Colors.white,
                  ),
                  title:
                      const Text("Home", style: TextStyle(color: Colors.white)),
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
                color: Color(0xFF3f37cc),
                elevation: 1,
                child: ListTile(
                  leading: Icon(
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
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );

                    //Navigator.pop(context);
                  },
                ),
              ),
              Card(
                color: Color(0xFF3f37cc),
                elevation: 1,
                child: ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
                  title: const Text("Log Out",
                      style: TextStyle(color: Colors.white)),
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
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text("${user?.email}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
