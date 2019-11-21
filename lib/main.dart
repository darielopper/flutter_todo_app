import 'dart:core';
import 'package:flutter/material.dart';
import 'package:todo_example/components/app.dart';
import 'package:flutter/services.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}