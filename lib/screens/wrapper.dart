import 'package:yuk_ngantri_user/models/user.dart';
import 'package:yuk_ngantri_user/screens/authenticate/authenticate.dart';
import 'package:yuk_ngantri_user/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    // return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
