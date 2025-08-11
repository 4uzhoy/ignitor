import 'dart:collection';

import 'package:flutter/widgets.dart';

class CommonActions extends ListBase<Widget> {
  // ignore: avoid_unused_constructor_parameters
  CommonActions(BuildContext context, [List<Widget>? actions])
    : _actions = <Widget>[...?actions];

  final List<Widget> _actions;

  @override
  int get length => _actions.length;

  @override
  set length(int newLength) => _actions.length = newLength;

  @override
  Widget operator [](int index) => _actions[index];

  @override
  void operator []=(int index, Widget value) => _actions[index] = value;
}
