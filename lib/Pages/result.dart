import 'dart:ui';

import 'package:cAR/CustomButton/CustomButton.dart';
import 'package:cAR/Pages/Menu/Menu.dart';
import 'package:cAR/Pages/RecordList/RecordList.dart';
import 'package:cAR/model/testResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

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
    var box = Hive.box('name');
    _textEditingController.text = box.get('nickname');
  }

  Future<bool> _updateUser() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('scores').get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var name = data['name'];

      List users = name.toString().split(' ');
      for (int i = 0; i < users.length; i++) {
        if (_textEditingController.text == users[i].toString()) {
          print('found !');
          print('same user ${users[i]}');
          FirebaseFirestore.instance
              .collection('scores')
              .doc('bRkXz0RBjWZeyctf1rTA')
              .update({
            'score': TestResultModel.testResult,
            'name': _textEditingController.text,
          });
          print('Updated user');
          return true;
        }
      }
    }
    return false;
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
              CustomButton(
                  text: 'Сохранить результат',
                  method: () {
                    if (TestResultModel.testResult == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Для сохранения нужно набрать >1')));
                    } else if (TestResultModel.testIsDone == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Пройдите тест')));
                    } else {
                      if (_textEditingController.text.length > 5 &&
                          TestResultModel.testResult > 0) {
                        final updateResult = _updateUser();
                        if (updateResult == true) {
                    
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Обновлено')));
                        } else {
                          users.add({
                            'name': _textEditingController.text,
                            'date': DateFormat('yMd')
                                .format(DateTime.now())
                                .toString(),
                            'score': TestResultModel.testResult,
                            'correctedFrom': 6 - TestResultModel.testResult
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Сохранено')));
                          }).catchError(
                              (error) => print('Error on push data!'));
                        }
                      }
                    }
                  },
                  icon: Icons.done_sharp),
              CustomButton(
                  text: 'К рекордам',
                  method: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RecordList()));
                  },
                  icon: Icons.arrow_back_ios_new_outlined),
              CustomButton(
                  text: 'В меню',
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Menu(
                              onSignOut: (arg) {},
                            )));
                  },
                  icon: Icons.arrow_back_ios_new_outlined),
              const SizedBox(
                height: 30,
              ),
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
          'Лучший!',
          style: TextStyle(color: Colors.white, fontSize: 17),
        );
    }
    return Text('empty');
  }
}
