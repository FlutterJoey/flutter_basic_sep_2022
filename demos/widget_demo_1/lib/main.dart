import 'package:flutter/material.dart';
import 'package:widget_demo_1/title.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    var state = titleKey.currentState;
    if (state != null) {
      state.tapText();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<AppTitleState> titleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ButtonCounter(
          counter: _counter,
          titleKey: titleKey,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ButtonCounter extends StatelessWidget {
  const ButtonCounter({
    Key? key,
    required this.titleKey,
    required int counter,
  })  : _counter = counter,
        super(key: key);

  final int _counter;
  final GlobalKey<AppTitleState> titleKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AppTitle(
          text: 'You have pushed the button this many times:',
          key: titleKey,
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
