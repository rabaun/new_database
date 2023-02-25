import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dialogs.dart';
import '../util/action_button.dart';

class _ProfileCard extends StatefulWidget {
  final void Function() removeProfile;
  final void Function() saveProfiles;
  final String studentKey;

  const _ProfileCard(this.removeProfile, this.saveProfiles,
      {Key? key, required this.studentKey})
      : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard>
    with TickerProviderStateMixin {
  bool _expanded = false;
  bool _showAreYouSureButton = false;

  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;
  late DatabaseReference reference;

  get student => dbRef.child(widget.studentKey).get();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Students').child(myUserId);
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.child(widget.studentKey).get();

    Map student = snapshot.value as Map;

    userNameController.text = student['name'];
    userAgeController.text = student['age'];
    userSalaryController.text = student['salary'];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            _expanded = !_expanded;
            if (_expanded) _showAreYouSureButton = false;
          });
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return EditProfileDialog(userNameController.text);
              });
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                userNameController.text,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing: Text(
                userAgeController.text,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              sizeCurve: Curves.decelerate,
              firstChild: Container(),
              secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ActionButton(
                                context,
                                icon: Icons.delete,
                                label: _showAreYouSureButton
                                    ? 'Вы уверены?'
                                    : 'Удалить',
                                onPressed: () {
                                  if (!_showAreYouSureButton) {
                                    setState(() {
                                      _showAreYouSureButton = true;
                                    });
                                  } else {
                                    widget.removeProfile.call();
                                  }
                                },
                              ),
                              ActionButton(
                                context,
                                icon: Icons.done_all,
                                label: 'Очистить',
                                onPressed: () {
                                  setState(() {
                                    reference.child(student['key']).remove();
                                  });
                                  reference.child(student['key']).remove();
                                },
                                disabled: true,
                              ),
                              ActionButton(
                                context,
                                icon: Icons.merge_type,
                                label: 'Объединить',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MergeDebtsDialog();
                                    },
                                  );
                                },
                              ),
                              ActionButton(
                                context,
                                icon: Icons.add,
                                label: 'Добавить',
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AddDebtDialog();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}