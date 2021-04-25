import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameControllers extends StatefulWidget {
  final Function onLeftPressed;
  final Function onRightPressed;
  final Function onUpPressed;
  final Function onDownPressed;
  final GameControllerState state;

  const GameControllers({
    Key key,
    this.onLeftPressed,
    this.onRightPressed,
    this.onUpPressed,
    this.onDownPressed,
    this.state}) : super(key: key);

  @override
  _GameControllersState createState() => _GameControllersState();
}

class _GameControllersState extends State<GameControllers> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0.0,
      child: Container(
        height: size.height / 2.5,
        width: size.width,
        child: Row(
          children: [
            Spacer(),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildButton(
                                icon: Icon(Icons.arrow_upward),
                                onTapDown: (_) {
                                  widget.onUpPressed?.call();
                                  widget.state.isUpPressed = true;
                                },
                                onTapCancel: () {
                                  widget.state.isUpPressed = false;
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildButton(
                              icon: Icon(Icons.arrow_back_outlined),
                              onTapDown: (_) {
                                widget.onLeftPressed?.call();
                                widget.state.isLeftPressed = true;
                              },
                              onTapCancel: () {
                                widget.state.isLeftPressed = false;
                              }),
                            SizedBox(width: 80.0,),
                            buildButton(
                                icon: Icon(Icons.arrow_forward_rounded),
                                onTapDown: (_) {
                                  widget.onRightPressed?.call();
                                  widget.state.isRightPressed = true;
                                },
                                onTapCancel: () {
                                  widget.state.isRightPressed = false;
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildButton(
                                icon: Icon(Icons.arrow_downward),
                                onTapDown: (_) {
                                  widget.onDownPressed?.call();
                                  widget.state.isDownPressed = true;
                                },
                                onTapCancel: () {
                                  widget.state.isDownPressed = false;
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget buildButton({Icon icon, void onTapDown(_), Function onTapCancel}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Material(
        color: Colors.white38,
        child: InkWell(
          onTapDown: onTapDown,
          onTap: onTapCancel,
          onTapCancel: onTapCancel,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: icon,
          ),
        ),
      ),
    );
  }
}

class GameControllerState {
  bool isUpPressed = false;
  bool isDownPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;
}
