// ignore_for_file: file_names

import 'dart:developer';

import 'package:cAR/Pages/record_list/record_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecordList extends StatefulWidget {
  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  late Stream<QuerySnapshot> _firebaseData;

  @override
  void initState() {
    super.initState();
    _firebaseData = FirebaseFirestore.instance
        .collection('scores')
        .orderBy('score', descending: true) // from the biggest to lower.
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        excludeHeaderSemantics: true,
        title: const Text('🔥 Рекорды:'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://images5.alphacoders.com/889/thumb-1920-889488.jpg',
                ))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<QuerySnapshot<dynamic>>(
              stream: _firebaseData, // still error
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                var data;
                try {
                  data = snapshot.data;
                } catch (e) {
                  log('$e');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const CircularProgressIndicator();
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
                      itemCount: data!.size,
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
      ),
    );
  }
}
