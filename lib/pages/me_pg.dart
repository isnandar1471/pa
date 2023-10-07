import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pa/providers/default_t_pvd.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '/helper.dart';
import '/routes/router.dart';
import '/widgets/btm_nav_bar_wgt.dart';

class MePg extends StatelessWidget {
  const MePg({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            ClipOval(
              child: Container(
                color: Colors.grey[300],
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black87,
                ),
              ),
            ),
            Text('Isnandar Fajar Pangestu'),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: [
                  _buildButton(
                    Icons.info_outline,
                    'About Application',
                    () {
                      ctx.pushNamed(RouteNames.me_aboutApplication.name);
                    },
                  ),
                  _buildButton(
                    Icons.help_outline,
                    'Change Server URL',
                    () {
                      showDialog(
                          context: ctx,
                          builder: (ctx) {
                            var serverUrlPvd = ctx.read<ServerUrlPvd>();
                            var serverUrl = serverUrlPvd.value;

                            var ctler = TextEditingController();
                            ctler.text = serverUrl;

                            return AlertDialog(
                              title: Text("Server URL"),
                              content: TextField(
                                controller: ctler,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => ctx.pop(),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    serverUrlPvd.value = ctler.text;
                                    ctx.pop();
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            );
                          });
                    },
                  ),
                  _buildButton(
                    Icons.help_outline,
                    'Help & Report',
                    () {
                      ctx.pushNamed(RouteNames.me_helpReport.name);
                    },
                  ),
                  _buildButton(Icons.people, 'invite friends', () async {
                    Uri? url = Uri.tryParse('https://www.google.com');
                    if (url == null) {
                      await showAlert(ctx, 'URL cannot be parsed');
                      return;
                    }

                    if ((await canLaunchUrl(url)) == false) {
                      await showAlert(ctx, 'URL cannot be launched');
                      return;
                    }

                    if ((await launchUrl(url, mode: LaunchMode.externalApplication)) == false) {
                      await showAlert(ctx, 'Failed Launch URL');
                    }
                  })
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BtmNavBarWgt(pageRoutesItemIdx: RouteNames.me_pg.index),
    );
  }

  Widget _buildButton(IconData icon, String text, void Function() onPressed) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(
          double.infinity,
          50,
        )),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(text),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.arrow_forward_ios, size: 15),
        ],
      ),
    );
  }
}
