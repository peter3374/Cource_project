// ignore_for_file: file_names

import 'package:cAR/Pages/RecordList/RecordListModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RecordList extends StatelessWidget {
  // const RecordList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('scores')
        .orderBy('score', descending: true) // from the biggest to lower.
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        excludeHeaderSemantics: true,
        title: const Text('Рекорды:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot<dynamic>>(
            stream: users,
            // stream: FirebaseFirestore.instance.collection('scores').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              final data = snapshot.requireData;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Подгружаю');
              }
              if (snapshot.hasError) {
                return const Text('Ошибка загрузки');
              }
              if (!snapshot.hasData) {
                return Column(
                  children: const [
                    Text('Загружаю'),
                    CircularProgressIndicator()
                  ],
                );
              } else {
                return ListView.builder(
                    itemCount: data.size,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TaskWidget(
                        score: data.docs[index]['score'],
                        time: '${data.docs[index]['date']}',
                        title: '${data.docs[index]['name']}',
                      );
                    });
              }
            }),
      ),
    );
  }
}
