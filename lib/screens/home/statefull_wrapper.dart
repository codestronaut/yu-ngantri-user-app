import 'package:flutter/material.dart';

class StatefullWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;

  StatefullWrapper({this.onInit, this.child});

  @override
  _StatefullWrapperState createState() => _StatefullWrapperState();
}

class _StatefullWrapperState extends State<StatefullWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
