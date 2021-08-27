import 'package:flutter/material.dart';
import 'package:time_tracker_final/app/home/account/account_page.dart';
import 'package:time_tracker_final/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_final/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_final/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;
  Map<TabItem, WidgetBuilder> get widgetBuilder {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
        widgetBuilder: widgetBuilder,
        currentTab: _currentTab,
        onSelectTab: _select);
  }
}
