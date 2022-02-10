import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/screens/post_form.dart';
import 'package:flutter_api_test/screens/post_screen.dart';
import 'package:flutter_api_test/screens/profile_screen.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';

import '../constant.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  // int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   PostScreen(),
  //   ProfileScreen(),
  // ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Blog App',
            style: robotoTextstyle(),
          ),
        ),
        body: Center(
          child: PostScreen(),
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
                      Icons.account_box_rounded,
                      color: Colors.white,
                    ),
                    title: const Text("Profile",
                        style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
