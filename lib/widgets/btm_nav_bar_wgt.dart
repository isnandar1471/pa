import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/routes/router.dart';

/// urutan berpengaruh
var btmNavBarItemMap = <int, BottomNavigationBarItem>{
  RouteNames.home_pg.index: BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
    tooltip: 'Show recently activity',
    backgroundColor: Colors.white,
  ),
  RouteNames.explore_pg.index: BottomNavigationBarItem(
    icon: Icon(Icons.explore),
    label: 'Explore',
    tooltip: 'Show articles, news, or posts',
    backgroundColor: Colors.white,
  ),
  RouteNames.activity_pg.index: BottomNavigationBarItem(
    icon: Icon(Icons.list_sharp),
    label: 'Activity',
    tooltip: 'Show complete history',
    backgroundColor: Colors.white,
  ),
  RouteNames.me_pg.index: BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Me',
    tooltip: 'Show application settings',
    backgroundColor: Colors.white,
  ),
};

List<BottomNavigationBarItem> get btmNavBarItemList {
  List<BottomNavigationBarItem> list = [];
  btmNavBarItemMap.forEach((key, value) {
    list.add(value);
  });
  return list;
}

class BtmNavBarWgt extends StatelessWidget {
  late int currIdx;

  BtmNavBarWgt({
    required int pageRoutesItemIdx,
  }) {
    BottomNavigationBarItem selectedBtmNavBarItem = btmNavBarItemMap[pageRoutesItemIdx]!;

    this.currIdx = btmNavBarItemList.indexOf(selectedBtmNavBarItem);
  }

  @override
  Widget build(BuildContext ctx) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black45,
      showUnselectedLabels: true,
      currentIndex: currIdx,
      onTap: (value) {
        switch (value) {
          case 0:
            ctx.goNamed(RouteNames.home_pg.name);
            break;
          case 1:
            ctx.goNamed(RouteNames.explore_pg.name);
            break;
          case 2:
            ctx.goNamed(RouteNames.activity_pg.name);
            break;
          default:
            ctx.goNamed(RouteNames.me_pg.name);
        }
      },
      items: btmNavBarItemList,
    );
  }
}
