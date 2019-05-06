import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCompletedScreen extends StatefulWidget {
  TaskCompletedScreen({
    Key key,
  }) : super(key: key);

  _TaskCompletedScreenState state;

  @override
  _TaskCompletedScreenState createState() {
    state = _TaskCompletedScreenState();
    return state;
  }
}

class _TaskCompletedScreenState extends State<TaskCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('todo')
                .where('done', isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data.documents.length > 0) {
                return ListView(
                    padding: EdgeInsets.all(2.0),
                    children: snapshot.data.documents
                        .map<Widget>((DocumentSnapshot document) {
                      return Card(
                        color: Colors.white70,
                        child: ListTile(
                          title: Text(document['title']),
                          trailing: Checkbox(
                            value: document['done'],
                            onChanged: (bool value) {
                              updateTask(document, !document['done']);
                            },
                          ),
                        ),
                      );
                    }).toList());
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("No data found.."),
                    ],
                  ),
                );
              }
            }),
      )),
    );
  }

  updateTask(DocumentSnapshot document, bool value) {
    Firestore.instance
        .document('todo/${document.documentID}')
        .updateData({'done': value});
  }

  deleteAllDoneTask() async {
    QuerySnapshot querys = await Firestore.instance
        .collection('todo')
        .where('done', isEqualTo: true)
        .getDocuments();
    querys.documents.forEach((document) {
      Firestore.instance.document('todo/${document.documentID}').delete();
    });
  }
}
