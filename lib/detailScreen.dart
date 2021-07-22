import 'package:device_controller/record.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Record data;

  DetailScreen(this.data);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<Map<String, List<FlSpot>>> initData() async {
    List<double> data = widget.data.datachanel1
        .trim()
        .replaceAll(',', ' ')
        .split(' ')
        .map((e) => double.parse(e))
        .toList();

    List<double> data2 = widget.data.datachanel2
        .trim()
        .replaceAll(',', ' ')
        .split(' ')
        .map((e) => double.parse(e))
        .toList();
    List<FlSpot> spots1 = List.generate(data.length ~/ 2,
        (index) => FlSpot(data[index * 2], data[index * 2 + 1])).toList();
    List<FlSpot> spots2 = List.generate(data2.length ~/ 2,
        (index) => FlSpot(data2[index * 2], data2[index * 2 + 1])).toList();

    return {'spots1': spots1, 'spots2': spots2};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Chi tiết'),
      ),
      body: FutureBuilder(
          future: initData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Patient ID: ${widget.data.patient_id}'),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                              maxContentWidth: 100,
                              tooltipBgColor: Colors.orange,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  final textStyle = TextStyle(
                                    color: touchedSpot.bar.colors[0],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  );
                                  return LineTooltipItem(
                                      '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                                      textStyle);
                                }).toList();
                              }),
                          handleBuiltInTouches: true,
                          getTouchLineStart: (data, index) => 0,
                        ),
                        minX: 0,
                        maxX: 120,
                        minY: 0,
                        maxY: 1000,
                        lineBarsData: [
                          LineChartBarData(
                            colors: [
                              Colors.black,
                            ],
                            spots: snapshot.data['spots1'],
                            isCurved: true,
                            isStrokeCapRound: true,
                            barWidth: 1,
                            belowBarData: BarAreaData(
                              show: false,
                            ),
                            dotData: FlDotData(show: false),
                          ),
                          LineChartBarData(
                            colors: [
                              Colors.blue,
                            ],
                            spots: snapshot.data['spots2'],
                            isCurved: true,
                            isStrokeCapRound: true,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: false,
                            ),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(
                            interval: 100,
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Colors.blueGrey, fontSize: 16),
                            margin: 16,
                          ),
                          bottomTitles: SideTitles(
                            interval: 20,
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Colors.blueGrey, fontSize: 16),
                            margin: 16,
                          ),
                          topTitles: SideTitles(showTitles: false),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                          checkToShowHorizontalLine: (value) {
                            return value.toInt() == 0;
                          },
                          checkToShowVerticalLine: (value) {
                            return value.toInt() == 0;
                          },
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
