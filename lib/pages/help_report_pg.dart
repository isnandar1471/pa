import 'package:flutter/material.dart';

class HelpReportPg extends StatelessWidget {
  const HelpReportPg({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Report'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          Text('data'),
        ],
      )),
    );
  }
}
