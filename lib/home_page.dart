import 'package:flutter/material.dart';
import 'crud_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // onPressed: () async {
          //   await FirebaseAuth.instance.signOut();
          //   Navigator.pop(context);
          // },
          // child: const Text('Sign Out'),
          
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FirestoreCRUDPage()), // Navigate to FirestoreCRUDPage
            );
          },
          child: const Text('CRUD Page'),
        ),
      ),
    );
  }
}