import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateRecordDebt extends StatefulWidget {
  const UpdateRecordDebt({Key? key, required this.debtsKey}) : super(key: key);

  final String debtsKey;

  @override
  State<UpdateRecordDebt> createState() => _UpdateRecordDebtState();
}

class _UpdateRecordDebtState extends State<UpdateRecordDebt> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Debts').child(myUserId);
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.child(widget.debtsKey).get();

    Map debts = snapshot.value as Map;

    userNameController.text = debts['name'];
    userAgeController.text = debts['age'];
    userSalaryController.text = debts['salary'];
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
                  Map<String, String> debts = {
                    'name': userNameController.text,
                    'age': userAgeController.text,
                    'salary': userSalaryController.text
                  };
                  dbRef
                      .child(widget.debtsKey)
                      .update(debts)
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