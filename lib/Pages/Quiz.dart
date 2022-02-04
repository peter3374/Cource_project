// ignore: file_names
// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:cAR/CustomButton/CustomButton.dart';
import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:cAR/Pages/dialogs.dart';
import 'package:cAR/Pages/result.dart';
import 'package:cAR/data/quizData.dart';
import 'package:cAR/model/testResult.dart';
import 'package:flutter/material.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({Key? key}) : super(key: key);

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Следующий вопрос";
  bool answered = false;
  @override
  void initState() {
    super.initState();
    customTimer();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _time = 40;
  Timer? timer;
  bool _isCanceled = false;

  void customTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _time--;

        if (_time == 0 || _isCanceled == true) {
          timer.cancel();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Время вышло!')));

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Menu(
                    onSignOut: (arg) {},
                  )));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Осталось : $_time сек.',
                  style: const TextStyle(color: Colors.white, fontSize: 23),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/quiz.jpg')),
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
            child: PageView.builder(
              controller: _controller!,
              onPageChanged: (page) {
                if (page == questions.length - 1) {
                  setState(() {
                    btnText = "Результат";
                  });
                }
                setState(() {
                  answered = false;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Вопрос ${index + 1}/${questions.length}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Text(
                        "${questions[index].question}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                    for (int i = 0; i < questions[index].answers!.length; i++)
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        margin: const EdgeInsets.only(
                            bottom: 20.0, left: 12.0, right: 12.0),
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          fillColor: Colors.blueAccent,
                          onPressed: !answered
                              ? () {
                                  if (questions[index]
                                      .answers!
                                      .values
                                      .toList()[i]) {
                                    score++;
                                    print(score);
                                  } else {
                                    print("no");
                                  }
                                  setState(() {
                                    CustomDialogsCollection.showCustomSnackBar(
                                        'Ответ принят');
                                    btnPressed = true;
                                    answered = true;
                                  });
                                }
                              : null,
                          child: Text(
                            questions[index].answers!.keys.toList()[i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        text: btnText,
                        method: () async {
                          if (_controller!.page?.toInt() ==
                              questions.length - 1) {
                            TestResultModel.testResult = score;
                            TestResultModel.testIsDone = true;
                            _isCanceled = true;
                            print(_isCanceled);
                            await Future.delayed(const Duration(seconds: 1));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResultTest()));
                          } else {
                            _controller!.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.fastOutSlowIn);

                            setState(() {
                              btnPressed = false;
                            });
                          }
                        },
                        icon: Icons.arrow_forward_ios),
                  ],
                );
              },
              itemCount: questions.length,
            )),
      ),
    );
  }
}