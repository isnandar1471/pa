import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart' as ppvd;
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '/providers/image_file_path_pvd.dart';
import '/routes/router.dart';

class _OnProcessManipulateImage with ChangeNotifier {
  bool _value = false;
  bool get value => this._value;
  void set value(bool value) {
    this._value = value;
    notifyListeners();
  }
}

typedef voidFunc = void Function();

class SemaphorePg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => _OnProcessManipulateImage(),
        ),
      ],
      child: _SemaphorePg(),
    );
  }
}

class _SemaphorePg extends StatelessWidget {
  // var _controller = ScrollController();

  @override
  Widget build(BuildContext ctx) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        var imagePathPvd = ctx.read<ImageFilePathPvd>();
        if (imagePathPvd.paths.length == 0) {
          ctx.pop(); // meng-pop semaphore_pg
          return;
        }
        showDialog<bool>(
          context: ctx,
          builder: (ctx) => AlertDialog(
            title: Text("Alert"),
            content: Text('data masih ada, yakin ingin keluar? data akan dihapus'),
            actions: [
              TextButton(
                onPressed: () {
                  ctx.pop(); // meng-pop dialog
                  ctx.pop(); // meng-pop semaphore_pg
                },
                child: Text('Ya'),
              ),
              TextButton(
                onPressed: () => ctx.pop(),
                child: Text('Tidak'),
              )
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Semaphore Photos'),
          actions: [
            (ctx.watch<_OnProcessManipulateImage>().value) ? CircularProgressIndicator() : Container(),
            Consumer<ImageFilePathPvd>(
              builder: (ctx, pvd, wgt) {
                voidFunc? onPressed = null;
                var tooltip = 'Add images before send';

                if (pvd.paths.length > 0) {
                  onPressed = () {
                    var imagefilepaths = pvd.paths;
                    ctx.pushNamed(RouteNames.home_semaphore_result_pg.name, queryParameters: {
                      'image-path-list': jsonEncode(imagefilepaths),
                    });
                  };

                  tooltip = 'Send images';
                }
                return IconButton(
                  onPressed: onPressed,
                  tooltip: tooltip,
                  disabledColor: Colors.grey,
                  icon: Icon(Icons.send),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 120, // height must exist
              child: Consumer<ImageFilePathPvd>(
                builder: (ctx, pvd, wgt) {
                  return ListView.builder(
                    // controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: pvd.paths.length,
                    itemBuilder: (ctx, idx) => InkWell(
                      onTap: () {
                        pvd.idxToShow = idx;
                      },
                      child: Container(
                        height: double.infinity,
                        width: 70,
                        child: Image.file(
                          File(pvd.paths[idx]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Consumer<ImageFilePathPvd>(
              builder: (ctx, pvd, _) {
                if (pvd.idxToShow == null) {
                  return Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(ctx).size.height - 294,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Tidak ada gambar yang dapat ditampilkan')
                        ],
                      ),
                    ),
                  );
                }
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: MediaQuery.of(ctx).size.height - 294,
                      child: Image.file(File(pvd.paths[pvd.idxToShow!])),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          pvd.paths = [
                            ...pvd.paths.sublist(0, pvd.idxToShow),
                            ...pvd.paths.sublist(pvd.idxToShow! + 1),
                          ];
                        },
                        tooltip: 'Delete image',
                        style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                            BorderSide(color: Colors.black),
                          ),
                        ),
                        icon: Icon(Icons.delete),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            onTap: (value) async {
              var imageFilePathPvd = ctx.read<ImageFilePathPvd>();

              var onProcessManipulateImage = ctx.read<_OnProcessManipulateImage>();
              onProcessManipulateImage.value = true;

              switch (value) {
                case 0:
                  var picker = ImagePicker();
                  var banyakPhoto = await picker.pickMultiImage();

                  if (banyakPhoto.length == 0) {
                    return;
                  }

                  for (int i = 0; i < banyakPhoto.length; i++) {
                    var aphoto = banyakPhoto[i];

                    var asdf = await img.decodeJpgFile(aphoto.path);

                    var width = asdf!.height ~/ 2;

                    var cropped = img.copyCrop(
                      asdf,
                      x: (asdf.width - width) ~/ 2,
                      y: 0,
                      width: width,
                      height: asdf.height,
                    );

                    var tmpDir = await ppvd.getTemporaryDirectory();

                    var tmpFilePath = p.join(tmpDir.path, 'cache1-' + aphoto.name);

                    await img.encodeImageFile(tmpFilePath, cropped);

                    imageFilePathPvd.paths = [
                      ...imageFilePathPvd.paths,
                      tmpFilePath,
                    ];
                  }
                  break;
                case 1:
                  var imagePathFromCameraPg = await ctx.pushNamed<List<String>>(RouteNames.home_camera_pg.name);
                  if (imagePathFromCameraPg != null) {
                    imageFilePathPvd.paths = [
                      ...imageFilePathPvd.paths,
                      ...imagePathFromCameraPg,
                    ];
                  }
                  break;
              }

              onProcessManipulateImage.value = false;
              // _controller.jumpTo(_controller.position.maxScrollExtent);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: 'Gallery',
                tooltip: 'Add from gallery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: 'Camera',
                tooltip: 'Add from camera',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
