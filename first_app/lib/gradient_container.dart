// import "package:first_app/styled_text.dart";
import "package:first_app/dice_roller.dart";
import "package:flutter/material.dart";

const beginAlignment = Alignment.topRight;
const endAlignment = Alignment.bottomLeft;

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key, required this.gradientColors});

  const GradientContainer.randomcolor({super.key})
      : gradientColors = const [
          Color.fromARGB(255, 247, 38, 23),
          Colors.lightGreenAccent
        ];
  final List<Color> gradientColors;
  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: beginAlignment,
          end: endAlignment,
        ),
      ),
      child: const Center(
        child: DiceRoller(),
      ),
    );
  }
}


/* Stateless Widget Example
class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key, required this.gradientColors});

  const GradientContainer.randomcolor({super.key})
      : gradientColors = const [
          Color.fromARGB(255, 247, 38, 23),
          Colors.lightGreenAccent
        ];
  final List<Color> gradientColors;
  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: beginAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dice-1.png',
              width: 200,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(top: 20),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 28),
              ),
              child: const Text('Roll Dice'),
            ),
          ],
        ),
      ),
    );
  }
}*/
