import 'package:yuk_ngantri_user/models/user.dart';
import 'package:yuk_ngantri_user/screens/wrapper.dart';
import 'package:yuk_ngantri_user/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF536DFE),
          accentColor: Color(0xFFFFFFFF),
        ),
        home: Wrapper(),
      ),
    );
  }
}
