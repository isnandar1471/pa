import 'package:flutter/material.dart';

class AboutAppPg extends StatelessWidget {
  const AboutAppPg({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('About Application'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('PENS Apps'),
                Text('version'),
                Icon(Icons.apple),
                Text('\u00a9 2022-2023 Pens Inc.'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
