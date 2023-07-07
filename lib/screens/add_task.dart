import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> addTaskToFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      var time = DateTime.now();
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(uid)
          .collection('my tasks')
          .doc(time.toString())
          .set({
        'title': titleController.text,
        'description': descriptionController.text,
        'time': time.toString(),
        'timestamp': time
      });
      Fluttertoast.showToast(msg: 'Data Added');

      // Pop the current route and return to the previous screen (home screen)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task')),
      backgroundColor: Colors.amber, // Set the background color to amber
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Builder(
              builder: (BuildContext context) {
                return Container(
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Title',
                      fillColor: Colors
                          .purple, // Set the text box background color to purple
                      filled: true,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Builder(
              builder: (BuildContext context) {
                return Container(
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Description',
                      fillColor: Colors
                          .purple, // Set the text box background color to purple
                      filled: true,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.deepPurple;
                      }
                      return Colors.purple;
                    },
                  ),
                ),
                onPressed: () {
                  addTaskToFirebase();
                },
                child: Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
