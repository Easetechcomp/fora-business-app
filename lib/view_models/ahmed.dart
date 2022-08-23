import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  int count = 0;
  void increaseCount() {
    setState(() {
      count++;
    });
  }

  void decreaseCount() {
    setState(() {
      count--;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: Text(count.toString()),
          ),
          Row(children: [
            Container(
                child: TextButton(
                    onPressed: decreaseCount,
                    child: const Icon(Icons.minimize_outlined))),
            Expanded(
                child: Container(
                    child: TextButton(
                        onPressed: increaseCount,
                        child: const Icon(Icons.add))))
          ])
        ],
      ),
    );
  }
}
