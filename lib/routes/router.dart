import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/pages/home_semaphore_result_pg.dart';
import '/pages/preview_pg.dart';
import '/pages/home_semaphore_pg.dart';
import '/providers/image_file_path_pvd.dart';
import 'package:provider/provider.dart';
import '/pages/about_app_pg.dart';
import '/pages/activity_pg.dart';
import '/pages/home_camera_pg.dart';
import '/pages/explore_pg.dart';
import '/pages/help_report_pg.dart';
import '/pages/home_pg.dart';
import '/pages/me_pg.dart';

enum RouteNames {
  splash,
  home_pg,
  explore_pg,
  activity_pg,
  me_pg,

  home_capture,
  home_camera_pg,
  home_semaphore_pg,
  home_semaphore_result_pg,
  home_preview,
  me_aboutApplication,
  me_helpReport,
}

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (ctx, state) {
        return '/home';
      },
    ),
    //
    GoRoute(
      name: RouteNames.home_pg.name,
      path: '/home',
      builder: (ctx, state) => HomePg(),
    ),
    GoRoute(
      name: RouteNames.home_camera_pg.name,
      path: '/home/camera',
      builder: (ctx, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider<ImageFilePathPvd>(create: (ctx) => ImageFilePathPvd()),
        ],
        child: CameraPg(),
      ),
    ),
    GoRoute(
      name: RouteNames.home_semaphore_pg.name,
      path: '/home/semaphore',
      builder: (ctx, state) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ImageFilePathPvd>(create: (ctx) => ImageFilePathPvd()),
          ],
          child: SemaphorePg(),
        );
      },
    ),
    GoRoute(
      name: RouteNames.home_semaphore_result_pg.name,
      path: '/home/semaphore/result',
      builder: (ctx, state) {
        if (state.uri.queryParameters.containsKey('image-path-list')) {
          List<dynamic> imagePaths = jsonDecode(state.uri.queryParameters['image-path-list']!);

          return HomeSemaphoreResultPg(imagePaths.map((imagePath) => imagePath.toString()).toList());
        }
        return Text('image-path-list query parameter doesnt exist');
      },
    ),
    GoRoute(
      name: RouteNames.home_preview.name,
      path: '/home/preview',
      builder: (ctx, state) {
        String? path = state.uri.queryParameters.containsKey('path') ? state.uri.queryParameters['path'] : null;
        return PreviewPg(path: path);
      },
    ),
    //
    GoRoute(
      name: RouteNames.explore_pg.name,
      path: '/explore',
      builder: (ctx, state) => ExplorePg(),
    ),
    //
    GoRoute(
      name: RouteNames.activity_pg.name,
      path: '/activity',
      builder: (ctx, state) => ActivityPg(),
    ),
    //
    GoRoute(
      name: RouteNames.me_pg.name,
      path: '/me',
      builder: (ctx, state) => MePg(),
    ),
    GoRoute(
      name: RouteNames.me_aboutApplication.name,
      path: '/me/about-app',
      builder: (ctx, state) => AboutAppPg(),
    ),
    GoRoute(
      name: RouteNames.me_helpReport.name,
      path: '/me/help-report',
      builder: (ctx, state) => HelpReportPg(),
    ),
  ],
);
