import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateRecordCredit extends StatefulWidget {
  const UpdateRecordCredit({Key? key, required this.creditsKey}) : super(key: key);

  final String creditsKey;

  @override
  State<UpdateRecordCredit> createState() => _UpdateRecordCreditState();
}

class _UpdateRecordCreditState extends State<UpdateRecordCredit> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Credits').child(myUserId);
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.child(widget.creditsKey).get();

    Map credits = snapshot.value as Map;

    userNameController.text = credits['name'];
    userAgeController.text = credits['number'];
    userSalaryController.text = credits['salary'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updating record'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Updating data in Firebase Realtime Database',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userAgeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'номер телефона',
                  hintText: 'Введите Ваш номер телефона',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userSalaryController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Salary',
                  hintText: 'Enter Your Salary',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, String> credits = {
                    'name': userNameController.text,
                    'number': userAgeController.text,
                    'salary': userSalaryController.text
                  };
                  dbRef
                      .child(widget.creditsKey)
                      .update(credits)
                      .then((value) => {Navigator.pop(context)});
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}