import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'view_student.dart';

class FirestoreCRUDPage extends StatefulWidget {
  const FirestoreCRUDPage({Key? key}) : super(key: key);

  @override
  _FirestoreCRUDPageState createState() => _FirestoreCRUDPageState();
}

class _FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('student');

  String documentID = ''; // Added field for document ID
   String newName = '';
   String newMatric = '';
   String newFaculty = '';
   String newProgramme = '';
   String newProgrammeCode = '';


  // Generate a random document ID
  String generateRandomDocumentID() {
    final String characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    final String id = String.fromCharCodes(
      Iterable.generate(20, (_) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
    return id;
  }

  Future<bool> isDocumentIDUnique(String id) async {
    final DocumentSnapshot document = await studentCollection.doc(id).get();
    return !document.exists;
  }

  Future<bool> doesMatricExist(String newMatric) async {
  final QuerySnapshot queryResult = await studentCollection.where('matric', isEqualTo: newMatric).get();
  return queryResult.docs.isNotEmpty;
}

  void createStudent() async {
    if (documentID.isEmpty) {
      documentID = generateRandomDocumentID();
    }

    final isUnique = await isDocumentIDUnique(documentID);
    final doesExist = await doesMatricExist(newMatric);

    if (!isUnique) {
      // Alert the user that the ID is not unique
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Duplicate Document ID'),
            content: Text('The Document ID already exists. Please choose a different one.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (doesExist) {
      // Alert the user that the matric already exists
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Duplicate Matric Number'),
            content: Text('The Matric Number already exists. Please choose a different one.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // The ID is unique, proceed with data creation
      await studentCollection.doc(documentID).set({
        'name': newName,
        'matric': newMatric,
        'faculty': newFaculty,
        'programme': newProgramme,
        'programme code': newProgrammeCode,
        'isDeleted': false,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        });
    }
  }

  void updateStudent() {
    studentCollection.doc(documentID).update({
      'name': newName,
      'matric': newMatric,
      'faculty': newFaculty,
      'programme': newProgramme,
      'programme code': newProgrammeCode,
      'isDeleted': false,
      'updated_at': FieldValue.serverTimestamp(),
      });
  }

  void deleteStudent() {
    studentCollection.doc(documentID).update({
      'isDeleted': true,
      'deleted_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Database'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  documentID = value;
                });
              },
              decoration: InputDecoration(labelText: 'Document ID (Leave empty to generate)'),
              ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newName = value;
                });
              },
              decoration: InputDecoration(labelText: 'New Name'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newMatric = value;
                });
              },
              decoration: InputDecoration(labelText: 'New Matric'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newFaculty = value;
                });
              },
              decoration: InputDecoration(labelText: 'New Faculty'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newProgramme = value;
                });
              },
              decoration: InputDecoration(labelText: 'New Programme'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newProgrammeCode = value;
                });
              },
              decoration: InputDecoration(labelText: 'New Programme Code'),
            ),
            ElevatedButton(
              onPressed: () {
                createStudent();
              },
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () {
                updateStudent();
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteStudent();
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewStudentsScreen()),
                );
              },
              child: Text('View'),
            ),
          ],
        ),
      ),
    );
  }
}