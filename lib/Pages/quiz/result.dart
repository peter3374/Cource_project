import 'dart:developer';
import 'dart:ui';

import 'package:cAR/Widgets/CustomButton.dart';
import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:cAR/Pages/RecordList/RecordList.dart';
import 'package:cAR/Widgets/dialogs.dart';
import 'package:cAR/model/testResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ResultTest extends StatefulWidget {
  const ResultTest({Key? key}) : super(key: key);

  @override
  State<ResultTest> createState() => _ResultTestState();
}

// DateFormat('yMd').format(DateTime.now()).toString(),
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
      ConfettiController(duration: const Duration(milliseconds: 500));
  @override
  void initState() {
    super.initState();
    print(TestResultModel.testResult);
    if (TestResultModel.testResult == 6) {
      _confettiController.play();
    }

    // hive
    _textEditingController.text = Hive.box('user_data').get('nickname');
  }

  Future<bool> _updateUser2() async {
    // Date now - ${DateFormat('yMd').format(DateTime.now())}
    var collection = await FirebaseFirestore.instance.collection('scores');
    // update
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
      // 'correctedFrom': 6 - TestResultModel.testResult
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Сохранено')));
    }).catchError((error) => print('Error on push data!'));
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('scores');
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
                width: 100,
                height: 120,
                child: Card(
                  color: TestResultModel.testResult >= 3
                      ? Colors.green
                      : Colors.red,
                  child: Center(
                    child: Text(
                      '${TestResultModel.testResult}',
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ),
              ),
              const Text(
                '/6 верно',
                style: TextStyle(color: Colors.white, fontSize: 20),
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
// test
                      FirebaseFirestore.instance
                          .collection('scores')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          // print(doc["score"]);
                          if (doc['score'] < TestResultModel.testResult) {
                            _updateUser2();
                            CustomDialogsCollection.showCustomSnackBar(
                                'Обновлено');
                          } else {
                            //     log('not updated! code line 177');
                            log('Pushing data');
                            _pushData();
                          }
                        });
                      });
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
              // CustomAuthButton(
              //     text: 'Обновить до 6 ',
              //     method: () {
              //       _updateUser2();
              //     },
              //     icon: Icons.arrow_back_ios_new_outlined),
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
          'Вы достигли дна',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 1:
        return const Text(
          'Ужасно',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 2:
        return const Text(
          'Плохо...',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 3:
        return const Text(
          'Средненько',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 4:
        return const Text(
          'Неплохо',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 5:
        return const Text(
          'Хорошо',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
      case 6:
        return const Text(
          'Заметачельно!',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
    }
    return const Text('empty');
  }
}
