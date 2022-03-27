import 'dart:developer';

import 'package:cAR/Pages/record_list/record_list.dart';
import 'package:cAR/Widgets/CustomButton.dart';
import 'package:cAR/Pages/Menu/Menu.dart';

import 'package:cAR/Widgets/dialogs.dart';
import 'package:cAR/data/quizData.dart';
import 'package:cAR/model/testResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ResultTest extends StatefulWidget {
  const ResultTest({Key? key}) : super(key: key);

  @override
  State<ResultTest> createState() => _ResultTestState();
}

class _ResultTestState extends State<ResultTest> {
  final TextEditingController _textEditingController = TextEditingController();
  static final List<Color> confettiColors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.blue,
    Colors.lime,
    Colors.green,
    Colors.purple,
    Colors.pink,
  ];

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(milliseconds: 800));
  @override
  void initState() {
    super.initState();
    if (TestResultModel.testResult == 10) {
      _confettiController.play();
    }
    // hive
    _textEditingController.text = Hive.box('user_data').get('nickname');
  }

  Future<bool> _updateUser2() async {
    var collection = FirebaseFirestore.instance.collection('scores');

    collection
        .doc(
            '${Hive.box('user_data').get('${Hive.box('user_data').get('id')}')}')
        .update({
      'date': DateFormat('yMd').format(DateTime.now()),
      'score': TestResultModel.testResult,
    }).then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Обновлено'))));
    return true;
  }

  Future<void> _pushData() async {
    await FirebaseFirestore.instance
        .collection('scores')
        .doc('${Hive.box('user_data').get('id')}')
        .set({
      'name': _textEditingController.text,
      'date': DateFormat('yMd').format(DateTime.now()).toString(),
      'score': TestResultModel.testResult,
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Сохранено')));
    });
  }

  Color _getQuizColor() {
    switch (TestResultModel.testResult) {
      case 0:
        return Colors.red;

      case 1:
        return Colors.red;

      case 2:
        return Colors.red;

      case 3:
        return Colors.red;

      case 4:
        return Color.fromARGB(255, 255, 136, 0);

      case 5:
        return Colors.orangeAccent;

      case 6:
        return Color.fromARGB(255, 46, 24, 247);

      case 7:
        return Colors.purpleAccent;

      case 8:
        return Colors.purple;

      case 9:
        return Colors.greenAccent;

      case 10:
        return Colors.green;
    }
    return Colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference _users =
        FirebaseFirestore.instance.collection('scores');
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/resultTest.jpg'))),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 150,
                height: 170,
                child: Card(
                  color: _getQuizColor(),
                  child: Center(
                    child: Text(
                      '${TestResultModel.testResult}/${Questions().questions.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SubText(
                  result: TestResultModel.testResult,
                  text: '',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                    readOnly: true,
                    enableSuggestions: true, // hints on keyboard
                    enableIMEPersonalizedLearning: true,
                    enableInteractiveSelection: true,
                    toolbarOptions: const ToolbarOptions(
                        copy: true, cut: true, paste: true, selectAll: true),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (String value) {},
                    controller: _textEditingController,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 25,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue.withOpacity(0.3),
                      counterStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: 'Ваш никнейм:',
                      hintStyle:
                          const TextStyle(color: Colors.white60, fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7)),
                    )),
              ),
              CustomAuthButton(
                  text: 'Сохранить результат',
                  method: () {
                    if (TestResultModel.testResult == 0) {
                      CustomDialogsCollection.showCustomSnackBar(
                          'Для сохранения нужно набрать >1');
                    } else if (!TestResultModel.testIsDone) {
                      CustomDialogsCollection.showCustomSnackBar(
                          'Пройдите тест');
                    } else if (TestResultModel.testResult > 0) {
                      // FirebaseFirestore.instance
                      //     .collection('scores')
                      //     .get()
                      //     .then((QuerySnapshot querySnapshot) {
                      //   for (var doc in querySnapshot.docs) {
                      //     // update Error
                      //     if (TestResultModel.testResult > doc['score'][0]) {
                      //       log('upd');
                      //       print(doc['score']);
                      //       _updateUser2();
                      //       // _pushData();
                      //       CustomDialogsCollection.showCustomSnackBar(
                      //           'Обновлено');
                      //     } else {
                      //       log('push');
                      //       _pushData();
                      //     }
                      //   }

                      // });
                      FirebaseFirestore.instance
                          .collection('scores')
                          .doc(
                              '${Hive.box('user_data').get('${Hive.box('user_data').get('id')}')}')
                          .get()
                          .then((doc) {
                        if (!doc.exists) {
                          log('push');
                          _pushData();
                        } else {
                          log('upd');
                          _updateUser2();
                        }
                      });

                      // if (FirebaseFirestore.instance.collection('scores').doc(
                      //         '${Hive.box('user_data').get('${Hive.box('user_data').get('id')}')}') ==
                      //     null) {
                      //   // push
                      //   log('push');
                      //   _pushData();
                      // } else {
                      //   //upd
                      //   log('upd');
                      //   _updateUser2();
                      // }
                    }
                  },
                  icon: Icons.done_sharp),
              CustomAuthButton(
                  text: 'К рекордам',
                  method: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RecordList()));
                  },
                  icon: Icons.arrow_back_ios_new_outlined),
              CustomAuthButton(
                  text: 'Поделиться',
                  method: () {
                    // int rez =

                    Share.share(
                        'Вау!😊 Мой рекод: ${TestResultModel.testResult} баллов из 6.',
                        subject: 'Невероятно.');
                  },
                  icon: Icons.send),

              CustomAuthButton(
                  text: 'В меню',
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Menu(
                              onSignOut: (arg) {},
                            )));
                  },
                  icon: Icons.home),
              const SizedBox(
                height: 30,
              ),
              // confetti
              Align(
                alignment: Alignment.centerLeft,
                child: ConfettiWidget(
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 50,
                  minBlastForce: 15, //def =5
                  colors: [
                    for (int i = 0; i <= confettiColors.length - 1; i++)
                      confettiColors[i]
                  ],
                  confettiController: _confettiController,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ConfettiWidget(
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 50,
                  minBlastForce: 15, //def =5
                  colors: [
                    for (int i = 0; i <= confettiColors.length - 1; i++)
                      confettiColors[i]
                  ],
                  confettiController: _confettiController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubText extends StatelessWidget {
  final int result;
  final String text;
  const SubText({Key? key, required this.text, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (result) {
      case 0:
        return const Text(
          'Пустота 💀',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 1:
        return const Text(
          'Шутишь? 🤨',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 2:
        return const Text(
          'Плохо 😠',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 3:
        return const Text(
          'Как так? 😑',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 4:
        return const Text(
          'Учись и давай еще раз 😏',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 5:
        return const Text(
          'Середина? 😌',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 6:
        return const Text(
          'Заметачельно!😏',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 7:
        return const Text(
          'Почти идеально😉',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 8:
        return const Text(
          'Знания есть 🙂',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 9:
        return const Text(
          'Вау 😎',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 10:
        return const Text(
          'Самый умный 🤓',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
    }
    return const Text('empty');
  }
}
