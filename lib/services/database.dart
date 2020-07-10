import 'package:yuk_ngantri_user/models/queue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection of users
  final CollectionReference users = Firestore.instance.collection('users');

  // collection of outside queue
  final CollectionReference outsideQueueRef =
      Firestore.instance.collection('outside_queue');

  // query of outside queue
  final Query outsideQueueQuery =
      Firestore.instance.collection('outside_queue').orderBy('date');

  // query of outside queue service a
  final Query outsideQueryA = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'A. Tanpa Kuasa');

  // query of outside queue service b
  final Query outsideQueryB = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'B. Penerimaan Berkas');

  // query of outside queue service c
  final Query outsideQueryC = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'C. Penyerahan Produk');

  // query of outside queue service d
  final Query outsideQueryD = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'D. Informasi');

  // collection of waaiting queue
  final CollectionReference waitingQueueRef =
      Firestore.instance.collection('waiting_room_queue');

  // query of waiting queue
  final Query waitingQueueQuery =
      Firestore.instance.collection('waiting_room_queue').orderBy('date');

  // query of waiting room queue service a
  final Query waitingQueryA = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'A. Tanpa Kuasa');

  final Query waitingQueryB = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'B. Penerimaan Berkas');

  final Query waitingQueryC = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'C. Penyerahan Produk');

  final Query waitingQueryD = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'D. Informasi');

  // collection reference 'ticket_number'
  final CollectionReference ticketNumberCollection =
      Firestore.instance.collection('ticket_number');

  // update user data
  Future updateUserData(String email, String deviceToken) async {
    return await users.document(uid).setData({
      'id': uid,
      'email': email,
      'device_token': deviceToken,
    });
  }

  // update queue data
  Future updateQueueData(CollectionReference ref, String ticketNumber,
      String service, String date) async {
    return await ref.document(uid).setData({
      'id': uid,
      'ticket_number': ticketNumber,
      'service': service,
      'date': date,
    });
  }

  // handle ticket number update
  Future updateTicketNumber(String ticketCode, int newTicketNumber) async {
    return await ticketNumberCollection.document(ticketCode).setData({
      'queue_ticket': newTicketNumber,
    });
  }

  // queue list from snapshot
  List<Queue> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Queue(
        id: doc.data['id'] ?? '',
        ticket: doc.data['ticket_number'] ?? '',
        service: doc.data['service'] ?? '',
        date: doc.data['date'] ?? '',
      );
    }).toList();
  }

  // get outside queue stream
  Stream<List<Queue>> get outsideQueues {
    return outsideQueueQuery.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesA {
    return outsideQueryA.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesB {
    return outsideQueryB.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesC {
    return outsideQueryC.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesD {
    return outsideQueryD.snapshots().map(_brewListFromSnapshot);
  }

  // get waiting queue stream
  Stream<List<Queue>> get waitingQueues {
    return waitingQueueQuery.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesA {
    return waitingQueryA.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesB {
    return waitingQueryB.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesC {
    return waitingQueryC.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesD {
    return waitingQueryD.snapshots().map(_brewListFromSnapshot);
  }
}
