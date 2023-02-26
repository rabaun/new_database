import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fragment_navigate/navigate-control.dart';
import 'package:new_database/screens/account_screen.dart';
import 'package:new_database/screens/credits_list_screen.dart';
import 'package:new_database/screens/debts_list_screen.dart';
import 'package:new_database/screens/login_screen.dart';
import 'package:new_database/screens/settings_screen.dart';

class Main extends StatelessWidget {
  static const String a = 'a';
  static const String b = 'b';
  static const String c = 'c';
  static const String d = 'd';
  static const String e = 'e';
  static const String f = 'f';
  static const String g = 'g';

  static User? user = FirebaseAuth.instance.currentUser;

  static final FragNavigate _fragNav = FragNavigate(
    firstKey: a,
    drawerContext: null,
    screens: <Posit>[
      Posit(
          key: a,
          title: 'Я должен',
          icon: Icons.input,
          fragmentBuilder: (dynamic p) => const DebtsList()),
      Posit(
          key: b,
          title: 'Мне должны',
          icon: Icons.input,
          fragmentBuilder: (p) => const CreditsList()),
      Posit(
          key: c,
          title: 'Profile',
          icon: Icons.verified_user,
          fragmentBuilder: (p) => Text(p as String)),
      Posit(
          key: d,
          title: 'SettingsD',
          icon: Icons.settings,
          fragmentBuilder: (p) => SettingsPage()),
      Posit(
          key: e,
          title: 'Feedback',
          icon: Icons.border_color,
          fragmentBuilder: (p) => Text(p as String)),
      Posit(
          key: f,
          title: 'Показать гид',
          icon: Icons.people,
          fragmentBuilder: (p) => Text(p as String)),
      Posit(
          key: g,
          title: 'Login',
          icon: Icons.exit_to_app,
          fragmentBuilder: (p) =>
              (user == null) ? const LoginScreen() : const AccountScreen()),
    ],
    actionsList: [
      ActionPosit(keys: [
        a,
        b,
        c,
        d,
        e,
        f,
        g
      ], actions: [
        IconButton(
          icon: const Icon(Icons.person),
          color: (user == null) ? Colors.white : Colors.yellow,
          onPressed: () => Posit(
              key: d,
              title: 'Login',
              icon: Icons.exit_to_app,
              fragmentBuilder: (p) =>
                  (user == null) ? const LoginScreen() : const AccountScreen()),
        )
      ])
    ],
  );

  Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _fragNav.setDrawerContext = context;

    return StreamBuilder<FullPosit>(
        stream: _fragNav.outStreamFragment,
        builder: (con, s) {
          if (s.data != null) {
            if (s.data?.params is Map) {
              print('Params passeds: ${s.data?.params}');
            }
            return DefaultTabController(
                length: s.data!.bottom?.length ?? 1,
                child: Scaffold(
                    key: _fragNav.drawerKey,
                    appBar: AppBar(
                      title: Text(s.data!.title ?? 'NULL'),
                      actions: s.data?.actions,
                      bottom: s.data?.bottom?.child,
                    ),
                    drawer: CustomDrawer(fragNav: _fragNav),
                    body: ScreenNavigate(
                        control: _fragNav,
                        child: Center(
                            child: (user == null)
                                ? const Text(
                                    "Контент для НЕ зарегистрированных в системе")
                                : s.data!.fragment
                        )
                    )
                )
            );
          }

          return Container();
        });
  }
}

class CustomDrawer extends StatelessWidget {
  final FragNavigate fragNav;

  const CustomDrawer({Key? key, required this.fragNav}) : super(key: key);

  Widget _getItem(
      {required String currentSelect,
      required text,
      required key,
      required icon}) {
    Color _getColor() => currentSelect == key ? Colors.white : Colors.black87;

    return Material(
        color: currentSelect == key ? Colors.blueAccent : Colors.transparent,
        child: ListTile(
            leading:
                Icon(icon, color: currentSelect == key ? Colors.white : null),
            selected: currentSelect == key,
            title: Text(text, style: TextStyle(color: _getColor())),
            onTap: () => fragNav.putPosit<int>(key: key, params: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          for (Posit item in fragNav.screenList.values)
            _getItem(
                currentSelect: fragNav.currentKey,
                text: item.drawerTitle ?? item.title,
                key: item.key,
                icon: item.icon)
        ],
      ),
    );
  }
}
