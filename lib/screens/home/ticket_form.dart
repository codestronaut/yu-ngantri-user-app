import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yuk_ngantri_user/services/auth.dart';
import 'package:yuk_ngantri_user/services/database.dart';
import 'package:flutter/material.dart';

class TicketForm extends StatefulWidget {
  @override
  _TicketFormState createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> services = [
    'A. Tanpa Kuasa',
    'B. Penerimaan Berkas',
    'C. Penyerahan Produk',
    'D. Informasi'
  ];

  // input text state
  String _visitorService;
  int _ticketNumber;
  String _ticketCode;
  String _visitorDate;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Text(
            'Daftar Antrian Baru',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          DropdownButtonFormField(
            hint: Text('Layanan'),
            items: services.map((service) {
              return DropdownMenuItem(
                value: service,
                child: Text(service),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _visitorService = val;
              });
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          ButtonTheme(
            height: 50.0,
            minWidth: double.infinity,
            child: RaisedButton(
              color: Color(0xFF536DFE),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Daftar',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
              onPressed: () async {
                if (_formKey.currentState.validate() &&
                    _visitorService != null) {
                  var currentDate = DateTime.now();
                  isLoading = true;

                  setState(() {
                    _visitorDate =
                        '${currentDate.hour}:${currentDate.minute}:${currentDate.second}';

                    if (_visitorService == 'A. Tanpa Kuasa') {
                      _ticketCode = 'latest_ticket_a';
                    } else if (_visitorService == 'B. Penerimaan Berkas') {
                      _ticketCode = 'latest_ticket_b';
                    } else if (_visitorService == 'C. Penyerahan Produk') {
                      _ticketCode = 'latest_ticket_c';
                    } else {
                      _ticketCode = 'latest_ticket_d';
                    }
                  });

                  await Firestore.instance
                      .collection('ticket_number')
                      .document(_ticketCode)
                      .get()
                      .then((value) {
                    setState(() {
                      _ticketNumber = value.data['queue_ticket'] + 1;
                    });
                  });

                  String finalTicket;

                  if (_ticketNumber.toString().length == 1) {
                    finalTicket =
                        "${_visitorService.split('.')[0]}00$_ticketNumber";
                  } else if (_ticketNumber.toString().length == 2) {
                    finalTicket =
                        "${_visitorService.split('.')[0]}0$_ticketNumber";
                  } else {
                    finalTicket =
                        "${_visitorService.split('.')[0]}$_ticketNumber";
                  }

                  var result =
                      await DatabaseService(uid: await AuthService().getUser())
                          .updateQueueData(
                    DatabaseService().outsideQueueRef,
                    finalTicket,
                    _visitorService,
                    _visitorDate,
                  );

                  if (result != null) {
                    setState(() {
                      isLoading = false;
                    });
                  }

                  await DatabaseService()
                      .updateTicketNumber(_ticketCode, _ticketNumber);
                } else {
                  Fluttertoast.showToast(
                      msg:
                          'Tolong pilih service untuk mendapatkan nomor antrian',
                      toastLength: Toast.LENGTH_SHORT);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      key: _formKey,
    );
  }
}
