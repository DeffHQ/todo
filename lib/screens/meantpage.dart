import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database.dart';
import '../models/note_model.dart';
import 'add_note_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class meantpage extends StatefulWidget {
  @override
  _meantpageState createState() => _meantpageState();
}

class _meantpageState extends State<meantpage> {
  late Future<List<Note>> _noteList;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    updateList();
  }

  List tasks = [];
  List isDone = [];

  Future<void> updateList() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore reference = FirebaseFirestore.instance;
    await reference
        .collection('Tasks')
        .doc(auth.currentUser!.email)
        .get()
        .then((value) {
      tasks = value.data()!['tasks'];
      isDone = value.data()!['isDone'];
      setState(() {
      });
    });
  }

  _updateNoteList()async {
    setState(() {

      _noteList = DatabaseHelper.instance.getNoteList();
    });
  }

  Widget _buildTaskDesign(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Card(
        elevation: 2.0,
        child: ListTile(
          title: Text(
            tasks[index],
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              decoration: !isDone[index]
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          trailing: Checkbox(
            onChanged: (value) {
              isDone[index] = value;
              setState(() {
                FirebaseAuth auth = FirebaseAuth.instance;
                FirebaseFirestore.instance
                    .collection('Tasks')
                    .doc(auth.currentUser!.email)
                    .set({'tasks': tasks, 'isDone': isDone},
                    SetOptions(merge: true));
              });

              // TODO:
              // change checkbox value in the list then update your UI and firebase ..
            }, // note.status = value! ? 1 : 0;
            // DatabaseHelper.instance.updateNote(note);
            // _updateNoteList();
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (_) => meantpage()));
            activeColor: Theme.of(context).primaryColor,
            value: isDone[index],
          ),
          onTap: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddNoteScreen(
                  updateNoteList: _updateNoteList(),
                ),
              ),
            );

            Timer(Duration(seconds: 2), () async {
              await updateList();
              print("timer called");
            });
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    await updateList();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    updateList();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddNoteScreen(
                updateNoteList: _updateNoteList,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body:tasks.isEmpty?SizedBox(): ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildTaskDesign(index);
        },
      ),
    );
  }
}