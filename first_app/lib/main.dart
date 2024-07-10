import "package:flutter/material.dart";
import 'package:first_app/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        // body: GradientContainer(gradientColors: [
        //   Color.fromARGB(255, 247, 11, 11),
        //   Color.fromARGB(255, 7, 237, 7),]
        body: GradientContainer.randomcolor(),
      ),
    ),
  );
}
