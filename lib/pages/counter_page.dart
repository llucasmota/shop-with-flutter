import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counter Page',
        ),
      ),
      body: Column(
        children: <Widget>[
          Text(CounterProvider.of(context)?.state.value.toString() ?? '0'),
          IconButton(
            onPressed: () {
              setState(() {
                CounterProvider.of(context)?.state.inc();
              });

              print(CounterProvider.of(context)?.state.value);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                CounterProvider.of(context)?.state.decrement();
              });
              print(CounterProvider.of(context)?.state.value);
            },
            icon: const Icon(
              Icons.remove,
            ),
          )
        ],
      ),
    );
  }
}
