// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_calculator_01/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var userQuestion = '';
  var userAnswer = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '(+/-)',
    '0',
    '.',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[20],
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        userQuestion,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        userAnswer,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 2,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  //clear button
                  if (index == 0) {
                    return MyButton(
                        color: Color.fromARGB(255, 6, 158, 11),
                        textColor: Colors.white,
                        buttonText: buttons[index],
                        buttonTap: () {
                          setState(() {
                            userQuestion = '';
                            userAnswer = '';
                          });
                        });
                  }
                  //delete button
                  else if (index == 1) {
                    return MyButton(
                        color: Color.fromARGB(255, 6, 158, 11),
                        textColor: Colors.white,
                        buttonText: buttons[index],
                        buttonTap: () {
                          setState(() {
                            userQuestion = userQuestion.substring(
                                0, userQuestion.length - 1);
                          });
                        });
                  }
                  //equal button
                  else if (index == buttons.length - 1) {
                    return MyButton(
                        color: Color.fromARGB(255, 6, 158, 11),
                        textColor: Colors.white,
                        buttonText: buttons[index],
                        buttonTap: () {
                          setState(() {
                            equalTapped();
                          });
                        });
                  }
                  //% button
                  else if (index == 2) {
                    return MyButton(
                        color: Color.fromARGB(255, 6, 158, 11),
                        textColor: Colors.white,
                        buttonText: buttons[index],
                        buttonTap: () {
                          setState(() {
                            double? questionAsNumber =
                                double.tryParse(userQuestion);
                            if (questionAsNumber != null) {
                              userQuestion =
                                  (questionAsNumber / 100).toString();
                            } else {
                              userQuestion = "Invalid input";
                            }
                          });
                        });
                  }
                  //(+/-) button
                  else if (index == 16) {
                    return MyButton(
                        color: Colors.green[50],
                        textColor: Colors.black,
                        buttonText: buttons[index],
                        buttonTap: () {
                          setState(() {
                            if (userQuestion.startsWith('-')) {
                              userQuestion = userQuestion.substring(1);
                            } else {
                              userQuestion = '-' + userQuestion;
                            }
                          });
                        });
                  }
                  //other buttons
                  else {
                    return MyButton(
                      buttonTap: () {
                        setState(() {
                          userQuestion += buttons[index];
                        });
                      },
                      color: isOperator(buttons[index])
                          ? Color.fromARGB(255, 6, 158, 11)
                          : Colors.green[50],
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.black,
                      buttonText: buttons[index],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == 'C' ||
        x == 'DEL' ||
        x == '%' ||
        x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=') {
      return true;
    }
    return false;
  }

  void equalTapped() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }
}
