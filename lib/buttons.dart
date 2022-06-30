import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final color;
  final textColor;
  final String text;
  final buttonPressed;

  CalculatorButton(this.color, this.textColor, this.text, this.buttonPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ElevatedButton(
          onPressed: () {
            buttonPressed(text);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: textColor),
          ),
        ),
      ),
    );
  }
}
