import 'package:common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:ignitor/src/features/initialization/controller/initialization.dart';
import 'package:ignitor/src/features/initialization/widget/application_root.dart';

void main() => appZone(() => runApp(ApplicationRoot($initializeApplication())));
