import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5),
      child: Center(
        child: SpinKitDoubleBounce(
          color: Color(0xFF536DFE),
          size: 50.0,
        ),
      ),
    );
  }
}
