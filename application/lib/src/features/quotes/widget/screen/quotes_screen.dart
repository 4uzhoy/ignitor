import 'package:control/control.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/common/widget/ignitor_app_bar.dart';
import 'package:ignitor/src/features/quotes/controller/quotes_controller.dart';
import 'package:ignitor/src/features/quotes/widget/layout/quotes_layout.dart';

class Quotes$Screen extends StatefulWidget {
  const Quotes$Screen({super.key});
  static String get routeName => '/quotes';
  @override
  State<Quotes$Screen> createState() => _Quotes$ScreenState();
}

class _Quotes$ScreenState extends State<Quotes$Screen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.controllerOf<QuotesController>().fetchQuotes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: IgnitorAppBar.none(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Quotes'),
    ),
    floatingActionButton: const QuotesScreen$Refresh(),
    body: const SafeArea(child: Quotes$Layout()),
  );
}

class QuotesScreen$Refresh extends StatelessWidget {
  const QuotesScreen$Refresh({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: () => context.controllerOf<QuotesController>().fetchQuotes(),
    tooltip: 'Refresh Quotes',
    child: const Icon(Icons.refresh),
  );
}
