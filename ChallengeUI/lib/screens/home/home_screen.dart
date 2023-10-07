import 'dart:async';

import 'package:challenge_ui/screens/home/home_schedules.dart';
import 'package:flutter/material.dart';

import 'home_date.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<DateTime> currentDateTime = StreamController.broadcast(sync: true);

  @override
  void initState() {
    currentDateTime.add(DateTime.now().copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewPadding = MediaQuery.of(context).viewPadding;

    return Scaffold(
        backgroundColor: const Color(0xFF1F1F1F),
        body: Padding(
          padding: viewPadding,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage:
                          NetworkImage("https://images.unsplash.com/photo-1608848461950-0fe51dfc41cb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80"),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      color: const Color(0xFFFFFFFF),
                      iconSize: 36,
                    ),
                  ],
                ),
              ),
              DateWidget(
                currentDateTime: currentDateTime,
              ),
              ScheduleWidget(currentDate: currentDateTime),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    currentDateTime.close();
    super.dispose();
  }
}
