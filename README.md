# flutter_no_internet_widget

[![flutter_no_internet_widget](https://github.com/NaagAlgates/flutter_no_internet_widget/actions/workflows/flutter_no_internet_widget_actions.yml/badge.svg)](https://github.com/NaagAlgates/flutter_no_internet_widget/actions/workflows/flutter_no_internet_widget_actions.yml)
[![codecov](https://codecov.io/gh/NaagAlgates/flutter_no_internet_widget/branch/master/graph/badge.svg?token=qvQsCoKrIz)](https://codecov.io/gh/NaagAlgates/flutter_no_internet_widget)

## Overview

A new Flutter widget shows online or offline screens without extra code or dependencies.

We need a lot of boilerplate code to check every project's network connectivity. Why can't there be a single package that takes care of everything and make the developer's life easy?

I also had the same question and have created this simple widget to help myself and others.

## Use case

The package's primary purpose is to show a default offline screen and a mandatory online screen provided while initializing.

Declare this widget at the top of the widget tree once. Whenever there is no internet, the default offline screen or the provided screen will be displayed.

## Example

```dart
InternetWidget(
 online: Text('Online'),
 offline: Text('offline),
 );
 ```

## Full Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: const FullScreenWidget(),
      // ignore: avoid_print
      whenOffline: () => print('No Internet'),
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: const Center(child: Text('Loading')),
      online: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SecondScreen(),
                    ),
                  );
                },
                child: const Text('Navigate'),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

## Video

![ezgif-3-b21b127bea](https://user-images.githubusercontent.com/14884575/169793453-4662e2b1-2be9-4f79-aaed-e2f489c1564d.gif)

## Use this package as a library

Run this command:

With Dart:

```dart
 dart pub add flutter_no_internet_widget
 ```

With Flutter:

```dart
 flutter pub add flutter_no_internet_widget
 ```

This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):

```dart
dependencies:
  flutter_no_internet_widget: [use_latest]
  ```
  
Alternatively, your editor might support dart pub get or flutter pub get. Check the docs for your editor to learn more.

Import it
Now in your Dart code, you can use:

```dart
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
```

## Maintainers

- [Nagaraj Alagusundaram](https://www.nagaraj.com.au)
