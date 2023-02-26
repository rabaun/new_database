import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_database/screens/credits_list_screen.dart';
import 'package:new_database/screens/debts_list_screen.dart';
import 'package:new_database/screens/settings_screen.dart';

import 'account_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('ООО "Центр Безопасности Труда"',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PlayfairDisplay',
                )),
            accountEmail: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Column(children: const [
                Text('email: cbt-tambov@yandex.ru',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'PlayfairDisplay',
                    )),
                Text('тел.: +7 (4752) 73-44-06',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'PlayfairDisplay',
                    )),
              ]),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image(
                image: AssetImage('assets/oldman.jpg'),
                // width: MediaQuery.of(context).size.width,
              ),
            ),
            otherAccountsPictures: const <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child:  Image(
                    image: AssetImage('assets/logo.png'),
              ))
            ],
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Я должен'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebtsList()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Мне должны'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreditsList()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreem()),
            )},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Показать гид'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: (user == null)
                ? const Text('Авторизоваться')
                : const Text('Выйти'),
            onTap: () => {
              (user == null)
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountScreen()),
                    )
            },
          ),
        ],
      ),
    );
  }
}
