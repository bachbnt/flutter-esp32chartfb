class Record {
  final int patient_id;
  final String datachanel1;
  final String datachanel2;

  Record({this.datachanel1, this.datachanel2, this.patient_id});

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
        patient_id: map['patient_id'],
        datachanel1: map['datachanel1'],
        datachanel2: map['datachanel2']);
  }
}
