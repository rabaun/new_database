import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:new_database/screens/update_record_debts_screen.dart';

import '../debts_dialogs.dart';

class DebtsList extends StatefulWidget {
  const DebtsList({Key? key}) : super(key: key);

  @override
  DebtsListState createState() => DebtsListState();
}

class DebtsListState extends State<DebtsList> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;
  late DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Debts').child(myUserId);
    reference = FirebaseDatabase.instance.ref().child('Debts').child(myUserId);
  }

  Widget _buildCard({required Map debts}) {
    return SizedBox(
      child: Card(
        child: Column(
          children: [
            ListTileTheme(
                contentPadding: const EdgeInsets.all(15),
                iconColor: Colors.red,
                textColor: Colors.black54,
                tileColor: Colors.yellow[100],
                style: ListTileStyle.list,
                dense: true,
                child: ListTile(
                  title: Text(
                    debts['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(debts['number']),
                  leading: Icon(Icons.account_circle,
                      color: Colors.blue[500], size: 30),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                        child: Text(
                          debts['salary'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateRecordDebt(debtsKey: debts['key']);
                            },
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => UpdateRecordDebt(
                          //             debtsKey: debts['key']))
                          // );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          reference.child(debts['key']).remove();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red[700],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    reference = FirebaseDatabase.instance.ref().child('Debts').child(myUserId);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/money.png'), fit: BoxFit.cover)),
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map debts = snapshot.value as Map;
            debts['key'] = snapshot.key;

            return (debts['key'] != null)
                ? Column(
                    children: [
                      _buildCard(debts: debts),
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AddDebtDialog();
            },
          );
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => AddDebtDialog()));
        },
      ),
    );
  }
}
