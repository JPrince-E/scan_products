import 'package:flutter/material.dart';
import 'package:scan_products/url_checker/view.dart';
import 'package:scan_products/view_products/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  TabBar get _tabBar => const TabBar(
        // labelColor: Colors.blue,
        // unselectedLabelColor: Colors.white,
        tabs: [
          Tab(
            text: "Upload Products",
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
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
