import 'package:flutter/material.dart';
import 'package:scan_products/url_checker/view.dart';
import 'package:scan_products/view_products/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  TabBar get _tabBar => const TabBar(
        labelStyle: TextStyle(color: Colors.white, fontSize: 30),
        unselectedLabelStyle: TextStyle(color: Colors.amber, fontSize: 30),
        indicatorWeight: 5,
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            text: "Create Products",
          ),
          Tab(
            text: "View Products",
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade800,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            bottom: _tabBar,
          ),
          body: const TabBarView(
            children: <Widget>[
              UrlCheckerPage(),
              ViewProductPage(),
            ],
          )),
    );
  }
}
