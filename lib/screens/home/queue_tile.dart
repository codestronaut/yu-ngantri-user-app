import 'package:flutter/material.dart';
import 'package:yuk_ngantri_user/models/queue.dart';

class QueueTile extends StatelessWidget {
  final Queue queue;
  final String userId;
  QueueTile({this.queue, this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: queue.id == userId ? Color(0xFF536DFE) : Colors.white,
        margin: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 0.0),
        child: ListTile(
          leading: Text(
            queue.ticket,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: queue.id == userId ? Colors.white : Colors.black,
            ),
          ),
          title: Text(
            queue.id == userId ? 'Nomor Antrian Saya' : queue.service,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
              color: queue.id == userId ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
