import 'dart:convert';

import 'package:pa/providers/default_t_pvd.dart';
import 'package:pa/schemas/semapahore_predict_multi.schema.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '/widgets/floating_action_button_widget.dart';
import '/widgets/btm_nav_bar_wgt.dart';
import '/routes/router.dart';
import '/providers/btm_nav_bar_pvd.dart';
import '/database_modeling/database.dart';
import '/main.dart';

var _DB = AppDatabase();

class _RecentActivityPvd extends DefaultTPvd<List<Widget>> {
  _RecentActivityPvd() : super([]);
}

// typedef Results = List<Result>;

// class _RecentActivityPvd2 extends DefaultTPvd<List<Results>> {
//   _RecentActivityPvd2() : super([]);
// }

class HomePg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => _RecentActivityPvd()),
        // ChangeNotifierProvider(create: (ctx) => _RecentActivityPvd2()),
      ],
      child: _HomePg(),
    );
  }
}

class _HomePg extends StatelessWidget {
  _HomePg();

  Future<void> onRefresh(BuildContext ctx) async {
    var recentActivities = await (_DB.select(_DB.semaphoreActivityTable)
          ..orderBy(
            [
              (u) => drift.OrderingTerm.desc(u.createdAt)
            ],
          )
          ..limit(5))
        .get();

    var recentActivityPvd = ctx.read<_RecentActivityPvd>();
    // var recentActivityPvd2 = ctx.read<_RecentActivityPvd2>();

    // recentActivityPvd2.value = _recentActivities.map((recentActivity) => (jsonDecode(recentActivity.jsonRanking) as List).map((item) => Result.fromJson(item)).toList()).toList();
    recentActivityPvd.value = recentActivities.map((recentActivity) {
      var results = (jsonDecode(recentActivity.jsonRanking) as List).map((item) => Result.fromJson(item)).toList();

      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network("${ctx.read<ServerUrlPvd>().value}/a/${results.first.fileName}", width: 50),
                Icon(
                  Icons.library_books,
                  color: results.length > 1 ? Colors.blueGrey : Colors.transparent,
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    results.map((result) => result.ranking.first.value).toList().join(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(recentActivity.createdAt * 1000).toLocal().toString(),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              constraints: BoxConstraints(),
              child: Icon(
                Icons.more_vert,
                size: 20,
              ),
              onSelected: (value) async {
                if (value == 'delete') {
                  await (_DB.delete(_DB.semaphoreActivityTable)..where((tbl) => tbl.id.equals(recentActivity.id))).go();

                  onRefresh(ctx);
                }
              },
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    enabled: false,
                    height: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 6,
                    ),
                    value: 'detail',
                    child: Text(
                      'Detail',
                    ),
                  ),
                  PopupMenuItem(
                    height: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 6,
                    ),
                    value: 'delete',
                    child: Text(
                      'Delete',
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext ctx) {
    onRefresh(ctx);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBtnWgt(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('PENS'),
      ),
      body: RefreshIndicator(
        onRefresh: () => onRefresh(ctx),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Highlight!'),
                      TextButton(
                        onPressed: () {
                          ctx.read<BtmNavBarIdxPvd>().val = RouteNames.explore_pg.index;

                          ctx.pushNamed(RouteNames.explore_pg.name);
                        },
                        child: Text('Show All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent Activities"),
                  TextButton(
                    onPressed: () {
                      ctx.read<BtmNavBarIdxPvd>().val = RouteNames.activity_pg.index;

                      ctx.pushNamed(RouteNames.activity_pg.name);
                    },
                    child: Text("Show All"),
                  )
                ],
              ),
            ),
            // DefaultTabController(
            //   length: 2,
            //   child: Container(
            //     child: TabBar(
            //       labelColor: Colors.white,
            //       // indicatorSize: TabBarIndicatorSize.values[1],
            //       indicator: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.brown,
            //       ),
            //       tabs: [
            //         Container(
            //           padding: EdgeInsets.symmetric(
            //             horizontal: 4,
            //           ),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(50),
            //             border: Border.all(
            //               color: Colors.brown,
            //               width: 1,
            //             ),
            //           ),
            //           child: Text("All"),
            //         ),
            //         Container(
            //           padding: EdgeInsets.symmetric(
            //             horizontal: 4,
            //           ),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(50),
            //             border: Border.all(
            //               color: Colors.brown,
            //               width: 1,
            //             ),
            //           ),
            //           child: Text("Semaphore"),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              width: double.infinity,
              child: Consumer<_RecentActivityPvd>(
                builder: (ctx, pvd, wgt) {
                  return (pvd.value.length == 0)
                      ? IntrinsicHeight(
                          child: Container(
                            alignment: Alignment.center,
                            height: double.infinity,
                            child: Text('Tidak Ada Aktivitas Terbaru'),
                          ),
                        )
                      : Column(
                          children: pvd.value,
                        );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BtmNavBarWgt(pageRoutesItemIdx: RouteNames.home_pg.index),
    );
  }
}
