import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

class ScheduleWidget extends StatefulWidget {
  ScheduleWidget({super.key, required this.currentDate});

  final StreamController<DateTime> currentDate;

  List<ScheduleModel> schedules = []
    ..add(ScheduleModel(startTime: "2023-10-07 10:30", endTime: "2023-09-27 11:40", title: "DESIGN MEETING", members: ['ALEX', 'HELENA', "NANA"]))
    ..add(ScheduleModel(startTime: "2023-10-07 12:35", endTime: "2023-09-27 13:55", title: "DAILY PROJECT", members: ['ME', 'RICHARD', "CIRY", "+4"]))
    ..add(ScheduleModel(startTime: "2023-10-07 14:00", endTime: "2023-09-27 16:40", title: "WEEKLY PLANNING", members: ['DEN', 'NANA', "MARK"]))
    ..add(ScheduleModel(startTime: "2023-10-07 17:00", endTime: "2023-09-27 19:00", title: "NOMAD CODING", members: ['ME', 'MARK', "HELENA"]))
    ..add(ScheduleModel(startTime: "2023-10-08 10:00", endTime: "2023-09-28 11:30", title: "DAILY PROJECT", members: ['ALEX', 'HELENA', "ALEX"]))
    ..add(ScheduleModel(startTime: "2023-10-08 12:30", endTime: "2023-09-28 14:00", title: "FLUTTER MEETING", members: ['HELENA', 'MARK', "NANA"]))
    ..add(ScheduleModel(startTime: "2023-10-08 15:20", endTime: "2023-09-28 16:40", title: "DAILY PROJECT", members: ['RICHARD', 'HELENA', "ALEX"]))
    ..add(ScheduleModel(startTime: "2023-10-08 16:50", endTime: "2023-09-28 19:40", title: "NOMAD CODING", members: ['ME', 'HELENA', "NANA"]))
    ..add(ScheduleModel(startTime: "2023-10-09 15:00", endTime: "2023-09-29 16:30", title: "MEET FRIENDS", members: ['ALEX', 'HELENA', "MARK"]))
    ..add(ScheduleModel(startTime: "2023-10-09 17:00", endTime: "2023-09-29 17:30", title: "DAILY PROJECT", members: ['MARK', 'ALEX', "NANA"]));

  @override
  State createState() => _ScheduleWidget();
}

class _ScheduleWidget extends State<ScheduleWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colors = [const Color(0xFFFAEDCB), const Color(0xFFC9E4DE), const Color(0xFFC6DEF1), const Color(0xFFDBCDF0), const Color(0xFFF2C6DE), const Color(0xFFF7D9C4)];
    var dateTimeFormat = DateFormat("yyyy-MM-dd hh:mm");

    return Flexible(
      flex: 1,
      child: StreamBuilder(
        stream: widget.currentDate.stream.asBroadcastStream(),
        builder: (context, snapshot) {
          print('currentDate in Schedules ${snapshot.data}');
          var daySchedules = widget.schedules.where((element) {
            var startDateTime = dateTimeFormat.parse(element.startTime);
            var endDateTime = dateTimeFormat.parse(element.endTime);

            if (snapshot.data != null) {
              var dayEnd = snapshot.data!.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);

              return snapshot.data!.isBefore(startDateTime) && dayEnd.isAfter(endDateTime) ||
                  snapshot.data!.isBefore(endDateTime) && dayEnd.isAfter(endDateTime) ||
                  startDateTime.isBefore(snapshot.data!) && endDateTime.isAfter(snapshot.data!) ||
                  startDateTime.isBefore(dayEnd) && endDateTime.isAfter(dayEnd);
            }
            return false;
          });

          return daySchedules.isEmpty
              ? const Center(
                  child: Text(
                    "Schdule is None!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (buildContext, index) {
                    var schedule = daySchedules.elementAt(index);
                    var startDateTime = dateTimeFormat.parse(schedule.startTime);
                    var endDateTime = dateTimeFormat.parse(schedule.endTime);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 14),
                        decoration: BoxDecoration(
                          color: colors[Random().nextInt(5)],
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(Radius.circular(32)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  sprintf("%02d", [startDateTime.hour]),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24, height: 1),
                                ),
                                Text(
                                  sprintf("%02d", [startDateTime.minute]),
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 1),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.black87,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  sprintf("%02d", [endDateTime.hour]),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24, height: 1),
                                ),
                                Text(
                                  sprintf("%02d", [endDateTime.minute]),
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 1),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 22,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    schedule.title,
                                    style: const TextStyle(
                                      fontSize: 52,
                                      height: 0.9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      for (var member in schedule.members)
                                        Row(
                                          children: [
                                            Text(
                                              member,
                                              style: TextStyle(color: member == 'ME' ? Colors.black : Colors.black45, fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            )
                                          ],
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: daySchedules.length,
                );
        },
      ),
    );
  }
}

class ScheduleModel {
  final String startTime;
  final String endTime;
  final String title;
  final List<String> members;

  ScheduleModel({required this.startTime, required this.endTime, required this.title, required this.members});
}
