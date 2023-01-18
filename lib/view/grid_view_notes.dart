import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_demo_todo/notification/notification.dart';
import 'package:hive_demo_todo/provider/provider.dart';
import 'package:intl/intl.dart';

class GridViewOfNotes extends StatelessWidget {
  GridViewOfNotes({super.key});

  DateTime currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final valueData = ref.watch(counterProvider);
            String data = DateFormat('hh:mm:ss').format(
                currentTime.add(Duration(seconds: valueData.value ?? 0)));
            return Column(
              children: [
                // Text(valueData.value.toString()),
                Text(
                  data,
                  style: const TextStyle(color: Colors.black),
                ),
                Center(
                  child: CupertinoButton(
                      pressedOpacity: 0.5,
                      color: Colors.blue,
                      child: const Text(
                        'Send Notification',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Notify.instantNotify();
                      }),
                ),
              ],
            );
          },
        ),
      ],
    ));
  }
}
