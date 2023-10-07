import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:camera/camera.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:pa/providers/default_t_pvd.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as ppvd;
import 'package:path/path.dart' as p;

import '/providers/btm_nav_bar_pvd.dart';
import '/routes/router.dart';
import '/l10n/l10n.dart';

var logger = new Logger();

late List<CameraDescription> cameras;

void main() {
  dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();

  availableCameras().then((cameraDescs) {
    cameras = cameraDescs;
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BtmNavBarIdxPvd()),
      ChangeNotifierProvider(create: (_) => ServerUrlPvd()),
    ],
    child: Main(),
  ));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext ctx) {
    Timer.periodic(
      Duration(milliseconds: 500),
      (timer) {
        if (dotenv.isInitialized) {
          ctx.read<ServerUrlPvd>().value = dotenv.get('BASE_API_URL');
          timer.cancel();
        }
      },
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Semaphore Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
