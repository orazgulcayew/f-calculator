import 'package:f_calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const App());
}

const animationDuration = 250;
Color backgroundColor = const Color(0xFF22252D);
Color lightColor = const Color(0xFFE7E7E7);
Color calculatorHolderColor = const Color(0xFF292D36);
Color textColor = const Color(0xFFFFFFFF);
Color buttonColor = const Color(0xFF1D1F25);
Color operatorColor = const Color(0xFFEB6666);
Color toolColor = const Color(0xFF26FAD4);
Color lightModeColor = const Color(0xFF707378);
Color darkModeColor = const Color(0xFFFFFFFF);

bool _isEnabled = true;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Calculator(),
        theme: ThemeData(useMaterial3: true));
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "0";
  String result = "0";
  String expression = "";

  void changeTheme(bool isEnabled) {
    if (isEnabled) {
      backgroundColor = const Color(0xFF22252D);
      calculatorHolderColor = const Color(0xFF292D36);
      textColor = const Color(0xFFFFFFFF);
      buttonColor = const Color(0xFF1D1F25);
      toolColor = const Color(0xFF26FAD4);
      lightModeColor = const Color(0xFF707378);
      darkModeColor = const Color(0xFFFFFFFF);
    } else {
      backgroundColor = const Color(0xFFFFFFFF);
      calculatorHolderColor = const Color(0xFFf5f5f5);
      textColor = const Color(0xFF292D36);
      buttonColor = const Color(0xFFF7F7F7);
      toolColor = const Color.fromARGB(255, 23, 152, 126);
      lightModeColor = const Color(0xFFEB6666);
      darkModeColor = const Color(0xFFDFDFDF);
    }
  }

  buttonPressed(String text) {
    setState(() {
      if (text == "AC") {
        equation = "0";
        result = "0";
      } else if (text == "C") {
        equation = "0";
      } else if (text == " = ") {
        expression = equation;
        expression = expression.replaceAll('x', '*');

        try {
          Parser parser = Parser();
          Expression exp = parser.parse(expression);
          ContextModel contextModel = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, contextModel)}';
          equation = "0";
        } catch (e) {
          result = "Ýalňyş amal";
          equation = "0";
        }
      } else if (text == "⌫") {
        if (equation.isNotEmpty) {
          if (equation.endsWith(" ")) {
            equation = equation.substring(0, equation.length - 3);
          } else {
            equation = equation.substring(0, equation.length - 1);
          }
        }
      } else {
        equation = equation == "0" ? equation = text : equation + text;
      }
    });
  }

  var styleOperators = TextStyle(color: operatorColor, fontSize: 40);

  bool isOperator(String str) {
    return str == "x" || str == "/" || str == "-" || str == "+" || str == "%";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        color: backgroundColor,
        duration: const Duration(milliseconds: animationDuration),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: animationDuration),
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: calculatorHolderColor),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        child: Icon(
                          Icons.light_mode,
                          color: lightModeColor,
                        ),
                        onTap: () {
                          setState(() {
                            if (_isEnabled) {
                              _isEnabled = !_isEnabled;
                              changeTheme(_isEnabled);
                            }
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        child: Icon(Icons.dark_mode, color: darkModeColor),
                        onTap: () {
                          setState(() {
                            if (!_isEnabled) {
                              _isEnabled = !_isEnabled;
                              changeTheme(_isEnabled);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: animationDuration),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    result,
                    style: TextStyle(color: textColor, fontSize: 30),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: animationDuration),
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  alignment: Alignment.bottomRight,
                  child: RichText(
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    text: TextSpan(
                      children: equation
                          .split(" ")
                          .map((e) => TextSpan(
                              text: "$e ",
                              style: isOperator(e)
                                  ? styleOperators
                                  : TextStyle(color: textColor, fontSize: 40)))
                          .toList(),
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: animationDuration),
                  decoration: BoxDecoration(
                    color: calculatorHolderColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                    child: Table(
                      children: [
                        TableRow(children: [
                          CalculatorButton(
                              buttonColor, toolColor, "AC", buttonPressed),
                          CalculatorButton(
                              buttonColor, toolColor, "⌫", buttonPressed),
                          CalculatorButton(
                              buttonColor, toolColor, "%", buttonPressed),
                          CalculatorButton(
                              buttonColor, operatorColor, " / ", buttonPressed),
                        ]),
                        TableRow(children: [
                          CalculatorButton(
                              buttonColor, textColor, "7", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "8", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "9", buttonPressed),
                          CalculatorButton(
                              buttonColor, operatorColor, " x ", buttonPressed),
                        ]),
                        TableRow(children: [
                          CalculatorButton(
                              buttonColor, textColor, "4", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "5", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "6", buttonPressed),
                          CalculatorButton(
                              buttonColor, operatorColor, " - ", buttonPressed),
                        ]),
                        TableRow(children: [
                          CalculatorButton(
                              buttonColor, textColor, "1", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "2", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "3", buttonPressed),
                          CalculatorButton(
                              buttonColor, operatorColor, " + ", buttonPressed),
                        ]),
                        TableRow(children: [
                          CalculatorButton(
                              buttonColor, textColor, "C", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, "0", buttonPressed),
                          CalculatorButton(
                              buttonColor, textColor, ".", buttonPressed),
                          CalculatorButton(
                              buttonColor, operatorColor, " = ", buttonPressed),
                        ]),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
