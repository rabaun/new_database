import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            accountName: const Text('Мое имя',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PlayfairDisplay',
                )),
            accountEmail: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Column(children: const [
                Text('мой email',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'PlayfairDisplay',
                    )),
                Text('мой телефон',
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
                image: AssetImage('assets/foto.png'),
                // width: MediaQuery.of(context).size.width,
              ),
            ),
            otherAccountsPictures: const <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black,
                child:  Image(
                  color: Colors.blue,
                    image: AssetImage('assets/month.png'),
              ))
            ],
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Профиль'),
            onTap: () => {  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            )},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Отзывы'),
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
