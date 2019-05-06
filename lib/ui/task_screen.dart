import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({
    Key key,
  }) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('todo')
                .where('done', isEqualTo: false)
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
      ),
    ));
  }

  updateTask(DocumentSnapshot document, bool value) {
    Firestore.instance
        .document('todo/${document.documentID}')
        .updateData({'done': value});
  }
}
