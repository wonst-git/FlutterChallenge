import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

const List<int> times = [15, 20, 25, 30, 35];
const int roundTotal = 2;
const int goalTotal = 4;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late int totalSeconds;

  int breakSeconds = 60 * 5;
  int selectIndex = 2;
  int roundCount = 0;
  int goalCount = 0;

  bool isRunning = false;
  bool isBreakTime = false;
  Timer? timer;

  @override
  void initState() {
    totalSeconds = times[selectIndex] * 60;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Theme.of(context).cardColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
        centerTitle: false,
        title: const Text(
          "POMOTIMER",
          textAlign: TextAlign.start,
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            isBreakTime ? "Break Time!" : "",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
          ),
          Expanded(
            flex: 1,
            child: TimerWidget(
              totalSeconds: totalSeconds,
              breakSeconds: breakSeconds,
              isBreakTime: isBreakTime,
            ),
          ),
          SelectTimeWidget(
            selectTimeIndex: selectIndex,
            onSelectTime: onSelectTime,
          ),
          const SizedBox(
            height: 80,
          ),
          ControlWidget(
            onStartPressed: onStartPressed,
            onStopPressed: onStopPressed,
            onReset: onReset,
            isRunning: isRunning,
          ),
          Expanded(
            flex: 1,
            child: StatusWidget(
              roundCount: roundCount,
              goalCount: goalCount,
            ),
          ),
        ],
      ),
    );
  }

  void onTick(Timer timer) {
    setState(() {
      if (isBreakTime) {
        if (breakSeconds == 1) {
          isBreakTime = false;
          totalSeconds = 60 * times[selectIndex];
        } else {
          breakSeconds--;
        }
      } else {
        if (totalSeconds == 1) {
          isBreakTime = true;
          breakSeconds = 60 * 5;
          roundCount++;
          if (roundCount == roundTotal) {
            roundCount = 0;
            goalCount++;

            if (goalCount == goalTotal) {
              onReset();
            }
          }
        } else {
          totalSeconds--;
        }
      }
    });
  }

  void onStartPressed() {
    isRunning = true;
    timer = Timer.periodic(const Duration(milliseconds: 3), onTick);
  }

  void onStopPressed() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onReset() {
    timer?.cancel();
    setState(() {
      isBreakTime = false;
      isRunning = false;
      totalSeconds = times[selectIndex] * 60;
      roundCount = 0;
      goalCount = 0;
    });
  }

  void onSelectTime(int index) {
    if (!isRunning) {
      setState(() {
        selectIndex = index;
        totalSeconds = times[selectIndex] * 60;
      });
    }
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key, required this.totalSeconds, required this.breakSeconds, required this.isBreakTime});

  final bool isBreakTime;
  final int totalSeconds;
  final int breakSeconds;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 100,
              height: 144,
              decoration: BoxDecoration(color: Colors.white54, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
            ),
            Container(
              width: 110,
              height: 140,
              decoration: BoxDecoration(color: Colors.white54, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
            ),
            Container(
              width: 120,
              height: 136,
              // color: Colors.white,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
              child: Text(
                sprintf("%02d", [isBreakTime ? breakSeconds ~/ 60 : totalSeconds ~/ 60]),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            ":",
            style: TextStyle(
              color: Colors.white24,
              fontSize: 80,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 100,
              height: 144,
              decoration: BoxDecoration(color: Colors.white54, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
            ),
            Container(
              width: 110,
              height: 140,
              decoration: BoxDecoration(color: Colors.white54, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
            ),
            Container(
              width: 120,
              height: 136,
              // color: Colors.white,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
              child: Text(
                sprintf("%02d", [isBreakTime ? breakSeconds % 60 : totalSeconds % 60]),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({super.key, required this.onSelectTime, required this.selectTimeIndex});

  final void Function(int index) onSelectTime;
  final int selectTimeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withOpacity(0), Theme.of(context).colorScheme.background])),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton(
              style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    const BorderSide(
                      color: Colors.white70,
                      width: 3,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(index == selectTimeIndex ? Colors.white : Theme.of(context).colorScheme.background)),
              onPressed: () {
                onSelectTime(index);
              },
              child: Text(
                times[index].toString(),
                style: TextStyle(
                  color: index == selectTimeIndex ? Theme.of(context).colorScheme.background : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
        itemCount: times.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class ControlWidget extends StatelessWidget {
  final void Function() onStopPressed;
  final void Function() onStartPressed;
  final void Function() onReset;

  final bool isRunning;

  const ControlWidget({super.key, required this.onStartPressed, required this.onStopPressed, required this.onReset, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: FilledButton(
            onPressed: isRunning ? onStopPressed : onStartPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black26),
              shape: MaterialStateProperty.all(const CircleBorder()),
              iconSize: MaterialStateProperty.all(60),
              iconColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: onReset,
            icon: const Icon(
              Icons.settings_backup_restore_outlined,
            ),
            iconSize: 40,
            color: Theme.of(context).cardColor,
          ),
        ),
      ],
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.roundCount, required this.goalCount});

  final int roundCount;
  final int goalCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$roundCount/$roundTotal',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'ROUND',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$goalCount/$goalTotal',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'GOAL',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
