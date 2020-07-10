import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:yuk_ngantri_user/models/queue.dart';
import 'package:yuk_ngantri_user/screens/home/queue_list.dart';
import 'package:yuk_ngantri_user/services/auth.dart';
import 'package:yuk_ngantri_user/services/database.dart';

class WaitingRoomList extends StatefulWidget {
  WaitingRoomList({Key key}) : super(key: key);

  @override
  _WaitingRoomListState createState() => _WaitingRoomListState();
}

class _WaitingRoomListState extends State<WaitingRoomList> {
  final AuthService _auth = AuthService();
  Stream<List<Queue>> queuesType = DatabaseService().waitingQueues;
  String serviceType;
  String service;
  bool isBooked = false;
  String topQueue;
  String servedQueue;

  getUserTicket() async {
    try {
      await Firestore.instance
          .collection('waiting_room_queue')
          .document(await _auth.getUser())
          .get()
          .then((value) {
        setState(() {
          serviceType = value.data['service'].toString().split('.')[0];
          service = value.data['service'];

          if (serviceType == null) {
            isBooked = false;
          } else {
            isBooked = true;
          }

          getListQueueOnService();

          // get top queue in waiting room
          Firestore.instance
              .collection('waiting_room_queue')
              .where('service', isEqualTo: service)
              .orderBy('date')
              .limit(1)
              .getDocuments()
              .then((value) {
            value.documents.forEach((element) {
              setState(() {
                topQueue = element.data['ticket_number'];
              });
            });
          });
        });
      });

      // get served queue
      await Firestore.instance
          .collection('served_queue')
          .where('service', isEqualTo: service)
          .orderBy('date')
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          setState(() {
            servedQueue = element.data['ticket_number'].toString();
          });
        });
      });
    } catch (e) {
      print(e.toString());
      print('Anda tidak sedang berada di ruang tunggu');
      // show toast
      Fluttertoast.showToast(
          msg: 'Anda tidak sedang berada di ruang tunggu',
          toastLength: Toast.LENGTH_SHORT);
      await Firestore.instance
          .collection('outside_queue')
          .document(await _auth.getUser())
          .get()
          .then((value) {
        setState(() {
          serviceType = value.data['service'].toString().split('.')[0];
          service = value.data['service'];

          if (serviceType == null) {
            isBooked = false;
          } else {
            isBooked = true;
          }

          getListQueueOnService();

          // get top queue in waiting room
          Firestore.instance
              .collection('waiting_room_queue')
              .where('service', isEqualTo: service)
              .orderBy('date')
              .limit(1)
              .getDocuments()
              .then((value) {
            value.documents.forEach((element) {
              setState(() {
                topQueue = element.data['ticket_number'];
              });
            });
          });
        });
      });

      // get served queue
      await Firestore.instance
          .collection('served_queue')
          .where('service', isEqualTo: service)
          .orderBy('date')
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          setState(() {
            servedQueue = element.data['ticket_number'].toString();
          });
        });
      });
    }
  }

  getListQueueOnService() {
    if (service == 'A. Tanpa Kuasa') {
      queuesType = DatabaseService().waitingQueuesA;
    } else if (service == 'B. Penerimaan Berkas') {
      queuesType = DatabaseService().waitingQueuesB;
    } else if (service == 'C. Penyerahan Produk') {
      queuesType = DatabaseService().waitingQueuesC;
    } else if (service == 'D. Informasi') {
      queuesType = DatabaseService().waitingQueuesD;
    } else {
      queuesType = DatabaseService().waitingQueues;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: PreferredSize(
        child: Material(
          elevation: 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isBooked
                          ? 'Informasi Loket $serviceType'
                          : 'Informasi Loket -',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFAB40),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      topQueue != null
                          ? 'Nomor antrian teratas: $topQueue'
                          : 'Nomor antrian teratas: -',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      servedQueue != null
                          ? 'Sedang dilayani: $servedQueue'
                          : 'Sedang dilayani: -',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                FlatButton.icon(
                  onPressed: () async {
                    getUserTicket();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(85.0),
      ),
      body: SafeArea(
          child: StreamProvider<List<Queue>>.value(
        value: queuesType,
        child: QueueList(),
      )),
    );
  }
}
