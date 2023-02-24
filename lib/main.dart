import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_database/screens/account_screen.dart';
import 'package:new_database/screens/fetch_data_screen.dart';
import 'package:new_database/screens/insert_data_screen.dart';
import 'package:new_database/screens/login_screen.dart';
import 'package:new_database/screens/reset_password_screen.dart';
import 'package:new_database/screens/signup_screen.dart';
import 'package:new_database/screens/update_record_screen.dart';
import 'package:new_database/screens/verify_email_screen.dart';
import 'package:new_database/services/firebase_streem.dart';

import 'dialogs.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/',
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.yellow,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: (user == null)
              ? const Text("Контент для НЕ зарегистрированных в системе")
              : const ProfilesList(),
          //child: Text('Контент для НЕ зарегистрированных в системе'),
        ),
      ),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              width: 300,
              height: 300,
              image: NetworkImage(
                  'https://seeklogo.com/images/F/firebase-logo-402F407EE0-seeklogo.com.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Firebase Realtime Database Series in Flutter 2022',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InsertData()));
              },
              child: const Text('Insert Data'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FetchData()));
              },
              child: const Text('Fetch Data'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilesList extends StatefulWidget {
  const ProfilesList({Key? key}) : super(key: key);

  @override
  ProfilesListState createState() => ProfilesListState();
}

class ProfilesListState extends State<ProfilesList> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;
  late DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Students').child(myUserId);
    reference =
        FirebaseDatabase.instance.ref().child('Students').child(myUserId);
  }

  Widget _buildCard({required Map student}) {
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
                  title: Text(student['name']),
                  subtitle: Text(student['age']),
                  leading: Icon(Icons.account_circle,
                      color: Colors.blue[500], size: 30),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                        child: Text(
                          student['salary'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => UpdateRecord(
                                      studentKey: student['key'])));
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
                          reference.child(student['key']).remove();
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
    Map? student;
    reference =
        FirebaseDatabase.instance.ref().child('Students').child(myUserId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Долговая книжка'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case MenuItem.removeAllProfiles:
                  setState(() {
                    reference.child(student?['key']).remove();
                  });
                  MaterialButton(
                    onPressed: () {
                      Map<String, String> students = {
                        'name': userNameController.text,
                        'age': userAgeController.text,
                        'salary': userSalaryController.text,
                      };

                      dbRef.push().set(students);
                    },
                  );
                  break;
                case MenuItem.onboarding:
                  Navigator.of(context).pushReplacementNamed('/onboarding');
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MenuItem.removeAllProfiles,
                child: Text('Удалить все профили'),
              ),
              PopupMenuItem(
                value: MenuItem.onboarding,
                child: Text('Показать гид'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map student = snapshot.value as Map;
            student['key'] = snapshot.key;

            return (student['key'] != null)
                ? Column(
                    children: [
                      _buildCard(student: student),
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
              return AddProfileDialog();
            },
          );
        },
      ),
    );
  }
}

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

class ActionButton extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final void Function() onPressed;
  final bool? disabled;

  const ActionButton(
    this.context, {
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.disabled,
  }) : super(key: key);

  Color getColor() {
    if (disabled == null || !disabled!)
      return Theme.of(context).buttonColor;
    else
      return Theme.of(context).disabledColor;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: (disabled == null || !disabled!) ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(
                icon,
                color: getColor(),
              ),
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: getColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuItem {
  removeAllProfiles,
  onboarding,
}
