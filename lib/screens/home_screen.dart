import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'account_screen.dart';
import 'credits_list_screen.dart';
import 'debts_list_screen.dart';
import 'login_screen.dart';
import 'nav_drawer_screen.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/money.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Center(
              child: (user == null)
                  ? const Text("Контент для НЕ зарегистрированных в системе")
                  : const DebtsList()),
        ),
      ),
      drawer: NavDrawer(),
    ));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  static final List _tabCount = ["Я должен", "Мне должны"];
  static const List<Widget> _views = [
    Center(child: FirstPage()),
    Center(child: CreditsList())
  ];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _views.length, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        final canSwipe = _tabController.index == 0;
        context.getSwipeablePageRoute<void>()!.canSwipe = canSwipe;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const Text('Долговая книжка'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)) {
                context.navigator.push<void>(
                    SwipeablePageRoute(builder: (_) => LoginScreen()));
              } else {
                context.navigator.push<void>(
                    SwipeablePageRoute(builder: (_) => AccountScreen()));
              }
            },
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.yellow,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: [
            for (var tab = 0; tab < _tabCount.length; tab++)
              Tab(text: '${_tabCount[tab]}'),
          ],
        ),
      ),
      drawer: NavDrawer(),
      body: TabBarView(controller: _tabController, children: _views),
    );
  }
}
