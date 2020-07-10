import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yuk_ngantri_user/models/queue.dart';
import 'package:yuk_ngantri_user/screens/home/queue_tile.dart';
import 'package:yuk_ngantri_user/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QueueList extends StatefulWidget {
  QueueList({Key key}) : super(key: key);

  @override
  _QueueListState createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final AuthService _auth = AuthService();
  String currentUserId;
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((event) {
        // save token or subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        // optional
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        // optional
      },
    );
  }

  _getCurrentUser() async {
    await _auth.getUser().then((id) {
      if (mounted) {
        setState(() {
          currentUserId = id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final queues = Provider.of<List<Queue>>(context) ?? [];

    return ListView.builder(
      itemBuilder: (context, index) {
        return QueueTile(
          queue: queues[index],
          userId: currentUserId,
        );
      },
      itemCount: queues.length,
    );
  }
}
