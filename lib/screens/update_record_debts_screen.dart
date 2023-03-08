import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateRecordDebt extends StatefulWidget {
  const UpdateRecordDebt({Key? key, required this.debtsKey})
      : super(key: key);

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
    userAgeController.text = debts['number'];
    userSalaryController.text = debts['salary'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Обновите данные по долгу',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/money.png'), fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Имя',
                    hintText: 'Введите имя',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: userAgeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Номер телефона',
                    hintText: 'Введите номер телефона',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: userSalaryController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Сумма',
                    hintText: 'Введите сумму',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  onPressed: () {
                    Map<String, String> debts = {
                      'name': userNameController.text,
                      'number': userAgeController.text,
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
                  child: const Text('Обновить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}