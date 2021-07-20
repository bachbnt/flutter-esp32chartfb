import 'package:device_controller/detailScreen.dart';
import 'package:device_controller/record.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final int patientId;

  HistoryItem({this.patientId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text('Patient ID: $patientId'),
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ref = FirebaseDatabase.instance.reference().child('acbd');

  Future<List<Record>> fetchList() async {
    List<Record> list = [];
    DataSnapshot snapshot = await ref.once();
    try {
      List<dynamic> raw = snapshot.value.values.toList();
      if (raw.length > 0) {
        raw.forEach((element) {
          list.add(Record(
            datachanel1: element['datachanel1'],
            datachanel2: element['datachanel2'],
            patient_id: element['patient_id'],
          ));
        });
      }
    } catch (err) {
      print(err);
    }
    print(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Lịch sử'),
      ),
      body: FutureBuilder(
          future: fetchList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(snapshot.data[index])),
                  );
                },
                child: HistoryItem(
                  patientId: snapshot.data[index].patient_id,
                ),
              ),
              itemCount: snapshot.data.length,
            );
          }),
    );
  }
}
