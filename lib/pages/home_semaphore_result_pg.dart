import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '/database_modeling/database.dart';
import '/schemas/semapahore_predict_multi.schema.dart';
import '/providers/default_t_pvd.dart';

class _OnLoadingPvd extends DefaultTPvd<bool> {
  _OnLoadingPvd() : super(true);
}

class _ResultListPvd extends DefaultTPvd<List<Result>> {
  _ResultListPvd() : super([]);
}

class HomeSemaphoreResultPg extends StatelessWidget {
  List<String> _imagePath;

  HomeSemaphoreResultPg(this._imagePath);

  @override
  Widget build(BuildContext ctx) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => _OnLoadingPvd()),
        ChangeNotifierProvider(create: (ctx) => _ResultListPvd()),
      ],
      child: _HomeSemaphoreResultPg(this._imagePath),
    );
  }
}

class _HomeSemaphoreResultPg extends StatefulWidget {
  List<String> _imagePaths;
  _HomeSemaphoreResultPg(this._imagePaths);
  @override
  State<_HomeSemaphoreResultPg> createState() => _HomeSemaphoreResultPgState();
}

class _HomeSemaphoreResultPgState extends State<_HomeSemaphoreResultPg> {
  Future<void> sendPredictMultiImageRequest(BuildContext ctx) async {
    var permissionStatus = await Permission.manageExternalStorage.request();
    if (permissionStatus.isDenied) {
      return;
    }

    ctx.read<_OnLoadingPvd>().value = true;
    var files = this.widget._imagePaths.map((imagePath) => File(imagePath)).toList();

    var request = http.MultipartRequest('POST', Uri.parse("${ctx.read<ServerUrlPvd>().value}/semaphores/predict/multi"));

    files.asMap().forEach((idx, image) {
      request.files.add(http.MultipartFile.fromBytes('files', image.readAsBytesSync().cast(), filename: 'file-${idx}.png'));
    });

    request
        .send()
        .timeout(Duration(
          seconds: int.parse(dotenv.get('APP_REQUEST_TIMEOUT_SECOND', fallback: '30')),
        ))
        .then((response) async {
      if (response.statusCode != 200) {
        return;
      }

      var stream = await response.stream.bytesToString();

      SemaphorePredictMulti semaphorePredictMultiResponse = SemaphorePredictMulti.fromJson(stream);

      var DB = AppDatabase();

      final jsonEncoder = JsonEncoder();

      DB.into(DB.semaphoreActivityTable).insert(
            SemaphoreActivityTableCompanion.insert(
              type: ActivityType.semaphore,
              jsonRanking: jsonEncoder.convert(semaphorePredictMultiResponse.result),
              createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            ),
          );

      ctx.read<_ResultListPvd>().value = semaphorePredictMultiResponse.result;
    }).onError<Exception>((error, stack) {
      showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                ctx.pop(); // meng-pop dialog
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }).whenComplete(() {
      ctx.read<_OnLoadingPvd>().value = false;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    sendPredictMultiImageRequest(ctx);

    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Stack(
        children: [
          Consumer<_ResultListPvd>(
            builder: (ctx, pvd, wgt) {
              if (pvd.value.length == 1) {
                return _SingleImageBody(pvd.value.first);
              }
              return _MultiImageBody(pvd.value);
            },
          ),
          Consumer<_OnLoadingPvd>(
            builder: (ctx, pvd, wgt) {
              if (pvd.value) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

class _SingleImageBody extends StatelessWidget {
  Result _predictionResult;

  _SingleImageBody(this._predictionResult);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Container(
          child: Image.network(
            "${ctx.read<ServerUrlPvd>().value}/a/${this._predictionResult.fileName}",
            width: 150,
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(this._predictionResult.ranking[1].value),
                  ),
                  Container(padding: EdgeInsets.all(5), child: Text('2')),
                  Container(padding: EdgeInsets.all(5), child: Text((this._predictionResult.ranking[1].probability * 100).toStringAsFixed(1))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(this._predictionResult.ranking[0].value),
                    ),
                    Container(padding: EdgeInsets.all(5), child: Text('1')),
                    Container(padding: EdgeInsets.all(5), child: Text((this._predictionResult.ranking[0].probability * 100).toStringAsFixed(1)))
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(this._predictionResult.ranking[2].value),
                  ),
                  Container(padding: EdgeInsets.all(5), child: Text('3')),
                  Container(padding: EdgeInsets.all(5), child: Text((this._predictionResult.ranking[2].probability * 100).toStringAsFixed(1)))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _MultiImageBody extends StatelessWidget {
  List<Result> _predictionResults;

  _MultiImageBody(this._predictionResults);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Container(
          child: Text(this._predictionResults.map((predictionResult) {
            return predictionResult.ranking[0].value;
          }).join('')),
        ),
        Container(
          child: Column(
            children: List.generate(
              this._predictionResults.length,
              (index) {
                var predictionResult = this._predictionResults[index];
                return Container(
                  child: Row(
                    children: [
                      Image.network(
                        "${ctx.read<ServerUrlPvd>().value}/a/${predictionResult.fileName}",
                        width: 100,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text('1'),
                              Text(predictionResult.ranking[0].value),
                              Text((predictionResult.ranking[0].probability * 100).toStringAsFixed(1)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('2'),
                              Text(predictionResult.ranking[1].value),
                              Text((predictionResult.ranking[1].probability * 100).toStringAsFixed(1)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('3'),
                              Text(predictionResult.ranking[2].value),
                              Text((predictionResult.ranking[2].probability * 100).toStringAsFixed(1)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
