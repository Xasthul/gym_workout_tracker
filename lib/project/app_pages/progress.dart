import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/project/classes/routes.dart';
import 'package:intl/intl.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  Exercise? chosenExercise;
  List<OneRepMaxData> _chartData = [];
  bool chartVisible = false;

  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        // Enables the trackball
        enable: true,
        lineType: TrackballLineType.none,
        markerSettings: const TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible),
        activationMode: ActivationMode.singleTap,
        hideDelay: 1250,
        tooltipSettings: const InteractiveTooltip(
          enable: true,
          color: Colors.brown,
          format: "point.x \n point.y kg",
        ));

    _zoomPanBehavior =
        ZoomPanBehavior(enablePinching: true, maximumZoomLevel: 0.3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Your Progress", style: TextStyle(fontSize: 21.sp)),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              chosenExercise =
                  await Navigator.of(context).push(routeToExercises());
              setState(() {
                if (chosenExercise != null &&
                    chosenExercise!.oneRepMax!.isNotEmpty) {
                  chartVisible = true;
                  final int exerciseID = chosenExercise!.id;
                  _chartData = objectbox.exerciseBox
                      .get(exerciseID)!
                      .oneRepMax!
                      .entries
                      .map((e) => OneRepMaxData(e.key, e.value))
                      .toList();
                } else {
                  chartVisible = false;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 32.w),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 24.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.black)),
              child: Row(
                children: [
                  Expanded(
                      child: Text(chosenExercise?.name ?? "Exercise",
                          style: TextStyle(fontSize: 20.sp))),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18.sp,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: chartVisible
                  ? SfCartesianChart(
                      primaryXAxis: DateTimeAxis(interval: 5),
                      trackballBehavior: _trackballBehavior,
                      zoomPanBehavior: _zoomPanBehavior,
                      series: <ChartSeries>[
                          LineSeries<OneRepMaxData, DateTime>(
                            name: "One Rep Max",
                            color: Colors.amber,
                            // markerSettings:
                            //     const MarkerSettings(isVisible: true),
                            dataSource: _chartData,
                            xValueMapper: (OneRepMaxData data, _) =>
                                DateFormat("dd.MM.yyyy").parse(data.date),
                            yValueMapper: (OneRepMaxData data, _) =>
                                data.weight,
                          ),
                        ])
                  : Center(
                      child: Text(
                      "No Data",
                      style: TextStyle(fontSize: 18.sp),
                    )),
            ),
          ),
        ],
      ),
    );
  }
}

class OneRepMaxData {
  OneRepMaxData(this.date, this.weight);

  final String date;
  final double weight;
}
