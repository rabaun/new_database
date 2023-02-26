import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCreditsDialog extends StatefulWidget {
  const AddCreditsDialog({Key? key}) : super(key: key);

  @override
  State<AddCreditsDialog> createState() => _AddCreditsDialogState();
}

class _AddCreditsDialogState extends State<AddCreditsDialog> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;
  late DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Credits').child(myUserId);
  }

  @override
  Widget build(BuildContext context) {
    var container = Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Имя',
                ),
                onSubmitted: (text) {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: userAgeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Номер телефона',
                ),
                onSubmitted: (text) {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: userSalaryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Сумма',
                ),
                onSubmitted: (text) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      height: 300,
      child: AlertDialog(
        title: Text("Добавить"),
        content: container,
        actions: [
          TextButton(
            onPressed: () {
              Map<String, String> credits = {
                'name': userNameController.text,
                'number': userAgeController.text,
                'salary': userSalaryController.text,
              };

              dbRef.push().set(credits);
              Navigator.pop(context);
            },
            child: Text('ДОБАВИТЬ'),
          ),
        ],
      ),
    );
  }
}
