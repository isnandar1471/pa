import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import '/routes/router.dart';
import 'package:provider/provider.dart';
import '/main.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as ppvd;

import '/providers/image_file_path_pvd.dart';

class _ItemIcon<T> {
  T item;
  IconData icon;
  _ItemIcon(this.item, this.icon);
}

class _IntPvd with ChangeNotifier {
  int _value = 0;

  int get value => this._value;

  void set value(int value) {
    this._value = value;

    notifyListeners();
  }
}

class _ImageFilePathPvd extends ImageFilePathPvd {}

class _FlashModeIdxPvd extends _IntPvd {}

class _ResolutionPresetIdxPvd extends _IntPvd {}

class CameraPg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => _ImageFilePathPvd()),
        ChangeNotifierProvider(create: (ctx) => _ResolutionPresetIdxPvd()),
        ChangeNotifierProvider(create: (ctx) => _FlashModeIdxPvd()),
      ],
      child: _CameraPg(),
    );
  }
}

class _CameraPg extends StatefulWidget {
  @override
  State<_CameraPg> createState() => _CameraPgState();
}

class _CameraPgState extends State<_CameraPg> {
  late CameraController _cameraController;

  var _flashIcon = <_ItemIcon<FlashMode>>[
    _ItemIcon(FlashMode.auto, Icons.flash_auto),
    _ItemIcon(FlashMode.always, Icons.flash_on),
    _ItemIcon(FlashMode.off, Icons.flash_off),
    _ItemIcon(FlashMode.torch, Icons.flashlight_on),
  ];

  var _resolutionIcon = <_ItemIcon<ResolutionPreset>>[
    /** 2 resolusi ini didisable karena masih bug distorsi camera preview*/
    // _ItemIcon(ResolutionPreset.low, Icons.low_priority),
    // _ItemIcon(ResolutionPreset.medium, Icons.density_medium),

    _ItemIcon(ResolutionPreset.high, Icons.high_quality),
    _ItemIcon(ResolutionPreset.veryHigh, Icons.verified),
    _ItemIcon(ResolutionPreset.ultraHigh, Icons.u_turn_left_sharp),
    _ItemIcon(ResolutionPreset.max, Icons.maximize),
  ];

  bool _isCameraEmpty = false;

  bool _isCameraInitialized = false;

  Future<void> _initiateNewCameraCtl(CameraController cameraController) async {
    setState(() {
      this._isCameraInitialized = false;
    });

    try {
      await this._cameraController.dispose();
    } catch (e) {
      inspect(e);
    }

    this._cameraController = cameraController;

    await this._cameraController.initialize();

    setState(() {
      this._isCameraInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();

    if (cameras.isEmpty) {
      this._isCameraEmpty = cameras.isEmpty;
      return;
    }

    var resolutionPresetIdxPvd = context.read<_ResolutionPresetIdxPvd>();

    this._initiateNewCameraCtl(CameraController(
      cameras.first,
      _resolutionIcon[resolutionPresetIdxPvd.value].item,
      enableAudio: false,
    ));
  }

  @override
  void dispose() async {
    await this._cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    if (_isCameraEmpty) {
      showDialog(
        context: ctx,
        builder: (ctx) => Text('There is no camera on this device'),
      );
    }

    var restOfHeight = MediaQuery.of(ctx).size.height - 84;
    var cameraWidthShould = restOfHeight / 2;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        var imagePathPvd = ctx.read<_ImageFilePathPvd>();
        if (imagePathPvd.paths.length == 0) {
          ctx.pop();
          return;
        }
        showDialog<bool>(
          context: ctx,
          builder: (ctx) => AlertDialog(
            title: Text("Alert"),
            content: Text('yakin ingin keluar? gambar yang telah ditangkap tidak akan disimpan'),
            actions: [
              TextButton(
                onPressed: () {
                  ctx.pop(); // meng-pop dialog
                  ctx.pop(); // meng-pop camera_pg
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
          title: Text('Camera App'),
        ),
        body: Stack(
          children: [
            Container(
              height: restOfHeight,
              // width: cameraWidth,
              child: Builder(
                builder: (ctx) {
                  if (this._isCameraInitialized) {
                    return RotatedBox(
                      quarterTurns: 0, // kadang perlu diganti 0 atau 1
                      child: AspectRatio(
                        aspectRatio: this._cameraController.value.aspectRatio,
                        child: CameraPreview(this._cameraController),
                      ),
                    );
                  }
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: restOfHeight,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(
                    width: (MediaQuery.of(ctx).size.width - cameraWidthShould) / 2,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: restOfHeight,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.black12,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ctx.watch<_ImageFilePathPvd>().paths.length + 2, // ditambah dengan 2 sebagai tempat sizedbox di awal dan di akhir
                      itemBuilder: (ctx, idx) {
                        var width = MediaQuery.of(ctx).size.width;

                        var imageFilePathPvd = ctx.read<_ImageFilePathPvd>();
                        if (idx == 0 || idx == imageFilePathPvd.paths.length + 1) {
                          // memberi sizedbox di awal dan di akhir agar gambar tidak terlalu dipinggir
                          return SizedBox(width: ((width - cameraWidthShould) / 2) + 10);
                        }

                        return InkWell(
                          onTap: () {
                            ctx.pushNamed(
                              RouteNames.home_preview.name,
                              queryParameters: {
                                'path': imageFilePathPvd.paths[idx - 1],
                              },
                            );
                          },
                          child: Container(
                            width: 50,
                            child: Image.file(File(imageFilePathPvd.paths[idx - 1])),
                          ),
                        );
                      },
                    ),
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ((MediaQuery.of(ctx).size.width - cameraWidthShould) / 2) + 10,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                            backgroundColor: MaterialStatePropertyAll(Colors.black26),
                          ),
                          tooltip: 'Toggle Flash Light',
                          onPressed: () async {
                            var flashModeIdxPvd = ctx.read<_FlashModeIdxPvd>();

                            flashModeIdxPvd.value = (flashModeIdxPvd.value + 1) % _flashIcon.length;

                            try {
                              await _cameraController.setFlashMode(_flashIcon[flashModeIdxPvd.value].item);
                            } catch (e) {
                              inspect(e);
                            }
                          },
                          icon: Icon(
                            _flashIcon[ctx.watch<_FlashModeIdxPvd>().value].icon,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                            backgroundColor: MaterialStatePropertyAll(Colors.black26),
                          ),
                          tooltip: 'Change Resolution',
                          onPressed: () async {
                            var resolutionPresetIdxPvd = ctx.read<_ResolutionPresetIdxPvd>();

                            resolutionPresetIdxPvd.value = (resolutionPresetIdxPvd.value + 1) % _resolutionIcon.length;

                            await this._initiateNewCameraCtl(
                              CameraController(
                                cameras.first,
                                _resolutionIcon[resolutionPresetIdxPvd.value].item,
                                enableAudio: false,
                              ),
                            );
                          },
                          icon: Icon(
                            _resolutionIcon[ctx.watch<_ResolutionPresetIdxPvd>().value].icon,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                            backgroundColor: MaterialStatePropertyAll(Colors.black12),
                          ),
                          tooltip: 'Capture Image',
                          onPressed: () async {
                            if (_cameraController.value.isTakingPicture) {
                              return;
                            }

                            img.Image? image;
                            late String name;
                            try {
                              var xfile = await _cameraController.takePicture();
                              name = xfile.name;

                              image = await img.decodeJpgFile(xfile.path);
                            } catch (e) {
                              logger.e(e);
                              return;
                            }

                            String? filePath;

                            try {
                              if (image == null) {
                                return;
                              }

                              var width = image.height ~/ 2;
                              var cropped = img.copyCrop(
                                image,
                                x: (image.width - width) ~/ 2,
                                y: 0,
                                width: width,
                                height: image.height,
                              );

                              var tmpDir = await ppvd.getTemporaryDirectory();

                              var tmpFilePath = p.join(tmpDir.path, 'cache1-' + name);

                              if (await img.encodeJpgFile(tmpFilePath, cropped)) {
                                filePath = tmpFilePath;
                              }
                            } catch (e) {
                              inspect(e);
                              return;
                            }

                            if (filePath != null) {
                              var imageFilePathPvd = ctx.read<_ImageFilePathPvd>();

                              imageFilePathPvd.paths = [
                                ...imageFilePathPvd.paths,
                                filePath
                              ];
                            }
                          },
                          icon: Icon(
                            Icons.camera,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                            backgroundColor: MaterialStatePropertyAll(Colors.black26),
                          ),
                          tooltip: 'Done',
                          onPressed: () {
                            ctx.pop(ctx.read<_ImageFilePathPvd>().paths);
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
