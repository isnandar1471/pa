import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/routes/router.dart';

class FloatingActionBtnWgt extends StatefulWidget {
  const FloatingActionBtnWgt({super.key});

  @override
  State<FloatingActionBtnWgt> createState() => _FloatingActionBtnWgtState();
}

class _FloatingActionBtnWgtState extends State<FloatingActionBtnWgt> {
  bool _newButtonOnPress = false;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: this._newButtonOnPress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        ctx.pushNamed(RouteNames.home_semaphore_pg.name);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Semaphore',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.flag,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ClipOval(
          child: InkWell(
            onTap: () {
              setState(() {
                this._newButtonOnPress = !this._newButtonOnPress;
              });
            },
            child: Container(
              color: this._newButtonOnPress ? Colors.brown : Colors.brown[400],
              padding: EdgeInsets.all(5),
              child: Icon(
                this._newButtonOnPress ? Icons.keyboard_arrow_down : Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
