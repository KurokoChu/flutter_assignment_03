import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewSubjectScreen extends StatefulWidget {
  @override
  _NewSubjectScreenState createState() => _NewSubjectScreenState();
}

class _NewSubjectScreenState extends State<NewSubjectScreen> {
  final _formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "Subject",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  }),
              RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    addTask();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    Firestore.instance
        .collection('todo')
        .add({'done': false, 'title': _controller.text});
  }
}
