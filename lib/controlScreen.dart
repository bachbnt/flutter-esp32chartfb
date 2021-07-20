import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool starting;
  final ref = FirebaseDatabase.instance.reference().child('abcde');

  Future<dynamic> fetchData() async {
    DataSnapshot snapshot = await ref.once();
    dynamic raw;
    try {
      raw = snapshot.value;
      setState(() {
        starting = raw['start'];
      });
    } catch (err) {
      print(err);
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Điều khiển'),
      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text('Kết nối'),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: snapshot.data['connected']
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                      onPressed: starting
                          ? null
                          : () {
                              ref.update({'start': true});
                            },
                      child: Text('Chạy')),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: !starting
                          ? null
                          : () {
                              ref.update({'start': false});
                            },
                      child: Text('Dừng')),
                ],
              ),
            );
          }),
    );
  }
}
