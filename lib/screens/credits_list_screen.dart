import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:new_database/screens/update_record_credits_screen.dart';

import '../credits_dialogs.dart';

class CreditsList extends StatefulWidget {
  const CreditsList({Key? key}) : super(key: key);

  @override
  CreditsListState createState() => CreditsListState();
}

class CreditsListState extends State<CreditsList> {
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
    reference = FirebaseDatabase.instance.ref().child('Credits').child(myUserId);
  }

  Widget _buildCard({required Map credits}) {
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
                    credits['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(credits['number']),
                  leading: Icon(Icons.account_circle,
                      color: Colors.blue[500], size: 30),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                        child: Text(
                          credits['salary'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateRecordCredit(
                                  creditsKey: credits['key']);
                            },
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => UpdateRecordCredit(
                          //             creditsKey: credits['key']))
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
                          reference.child(credits['key']).remove();
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
    reference =
        FirebaseDatabase.instance.ref().child('Credits').child(myUserId);
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
            Map credits = snapshot.value as Map;
            credits['key'] = snapshot.key;

            return (credits['key'] != null)
                ? Column(
                    children: [
                      _buildCard(credits: credits),
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
              return const AddCreditsDialog();
            },
          );
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => AddCreditsDialog()));
        },
      ),
    );
  }
}
