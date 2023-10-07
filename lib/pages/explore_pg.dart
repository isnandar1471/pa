import 'package:flutter/material.dart';
import 'package:pa/main.dart';
import '/routes/router.dart';
import '/widgets/btm_nav_bar_wgt.dart';

class ExplorePg extends StatelessWidget {
  ExplorePg({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explore'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          logger.i('onrefresh in explore');
        },
        child: ListView(
          children: [
            Container(
              child: Text('Articles'),
            ),
            Container(
              child: Placeholder(),
            ),
            Container(
              child: Text('News'),
            ),
            Container(
              child: Placeholder(),
            ),
            Container(
              child: Text('Posts'),
            ),
            Container(
              child: Placeholder(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BtmNavBarWgt(pageRoutesItemIdx: RouteNames.explore_pg.index),
    );
  }
}
