import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pa/providers/default_t_pvd.dart';
import 'package:pa/schemas/semapahore_predict_multi.schema.dart';
import 'package:provider/provider.dart';

import '/database_modeling/database.dart';
import '/main.dart';
import '/routes/router.dart';
import '/widgets/btm_nav_bar_wgt.dart';

var _DB = AppDatabase();

class _RecentActivityPvd extends DefaultTPvd<List<Widget>> {
  _RecentActivityPvd() : super([]);
}

class ActivityPg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => _RecentActivityPvd()),
      ],
      child: _ActivityPg(),
    );
  }
}

class _ActivityPg extends StatelessWidget {
  const _ActivityPg();

  Future<void> onRefresh(BuildContext ctx) async {
    var recentActivities = await (_DB.select(_DB.semaphoreActivityTable)
          ..orderBy(
            [
              (u) => drift.OrderingTerm.desc(u.createdAt)
            ],
          ))
        .get();

    var recentActivityPvd = ctx.read<_RecentActivityPvd>();

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Activity'),
      ),
      body: RefreshIndicator(
        onRefresh: () => onRefresh(ctx),
        child: Consumer<_RecentActivityPvd>(
          builder: (ctx, pvd, wgt) {
            return (pvd.value.length == 0)
                ? ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(ctx).size.height - 200,
                        child: Text('Tidak Ada Aktivitas Terbaru'),
                      )
                    ],
                  )
                : ListView(
                    children: pvd.value,
                  );
          },
        ),
        // ListView(
        //   children: [],
        // ),
      ),
      bottomNavigationBar: BtmNavBarWgt(pageRoutesItemIdx: RouteNames.activity_pg.index),
    );
  }
}
