import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DateWidget extends StatefulWidget {
  const DateWidget({super.key, required this.currentDateTime});

  final StreamController<DateTime> currentDateTime;

  @override
  State createState() => _DateWidget();
}

class _DateWidget extends State<DateWidget> {
  DateTime today = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0);
  ScrollController scrollController = ScrollController();

  StreamController<DateTime> currentDate = StreamController();
  StreamController<bool> isLeft = StreamController();

  void animateScrollLeft() {
    scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    super.initState();

    currentDate.add(today);
    isLeft.add(true);

    scrollController.addListener(() {
      var currentPosition = (scrollController.offset - 20 )/ 64;
      var date = today.copyWith(day: today.day + currentPosition.toInt());
      currentDate.add(date);

      isLeft.add(scrollController.offset == 0);
    });
  }

  @override
  void dispose() {
    currentDate.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<DateTime>(
                stream: currentDate.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      DateFormat("MMMM EEEE dd").format(snapshot.data ?? DateTime.now()),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: isLeft.stream,
                builder: (context, snapshot) {
                  return snapshot.data == true
                      ? Container()
                      : MaterialButton(
                          clipBehavior: Clip.hardEdge,
                          onPressed: animateScrollLeft,
                          shape: CircleBorder(),
                          colorBrightness: Brightness.dark,
                          child: const Icon(Icons.keyboard_arrow_left),
                        );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: StreamBuilder<DateTime>(
              stream: widget.currentDateTime.stream.asBroadcastStream()!,
              builder: (context, snapshot) {
                print('currentDate in Date ${snapshot.data}');
                return ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var date = today.copyWith(day: today.day + index);

                    return TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            today == date ? "TODAY" : "${date.day}",
                            style: TextStyle(color: snapshot.data == date ? Colors.white : Colors.white60, fontSize: 18),
                          ),
                          if (snapshot.data == date)
                            Container(
                              padding: EdgeInsets.only(left: 4),
                              child: Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple),
                                height: 4,
                                width: 4,
                              ),
                            ),
                        ],
                      ),
                      onPressed: () {
                        widget.currentDateTime.add(date);
                      },
                    );
                  },
                  itemCount: 1000,
                );
              }),
        ),
      ],
    );
  }
}
