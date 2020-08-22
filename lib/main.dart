import 'dart:io';
import 'package:flutter/material.dart';
import 'package:future_builder_app/widget/baby_products.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
  const twentyMillis = const Duration(seconds: 60);
  new Timer(twentyMillis, () => deleteCa());
}

deleteCa() async {
  appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: BabyProduct());
  }
}
