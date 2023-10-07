import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPg extends StatelessWidget {
  String? path = null;

  Image? _img = null;

  PreviewPg({required this.path}) {
    if (this.path != null) {
      _img = Image.file(File(path!));
    }
  }

  Future<Size> _getImgSize() async {
    var completer = Completer<Size>();
    _img!.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          completer.complete(Size(image.image.width.toDouble(), image.image.height.toDouble()));
        },
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return Text('IMAGE DOESNT EXIST');
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        _img!,
        Container(
          child: FutureBuilder<Size>(
            builder: (ctx, snap) {
              return RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: 'height : '),
                    TextSpan(text: snap.data!.height.toString()),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'width : '),
                    TextSpan(text: snap.data!.width.toString()),
                    TextSpan(text: '\n'),
                  ],
                ),
              );
            },
            future: this._getImgSize(),
          ),
        ),
      ],
    );
  }
}
