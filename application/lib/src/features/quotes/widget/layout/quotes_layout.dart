import 'package:control/control.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';
import 'package:ignitor/src/features/quotes/controller/quotes_controller.dart';
import 'package:ignitor/src/features/quotes/widget/layout/quotes_layout_succesful.dart';
import 'package:ui/ui.dart';

class Quotes$Layout extends StatelessWidget {
  const Quotes$Layout({super.key});

  @override
  Widget build(BuildContext context) =>
      StateConsumer<QuotesController, QuotesState>(
        controller: context.dependencies.quotesController,
        listener: (context, controller, previous, current) {
          if (current is QuotesState$Error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${current.error}')));
          }
          if (current is QuotesState$Successful) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fetched ${current.quotes.length} quotes'),
              ),
            );
          }
        },
        builder:
            (context, state, child) => switch (state) {
              QuotesState$Processed(quotes: final quotes) => LoadingOverlay(
                inProgress: true,
                child: Quotes$Layout$Successful(quotes: quotes),
              ),
              QuotesState$Error(error: final error) => Center(
                child: Text(
                  'Error: $error',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              QuotesState$Idle() => const Center(
                child: Text('No quotes available'),
              ),
              QuotesState$Successful(quotes: final quotes) =>
                Quotes$Layout$Successful(quotes: quotes),
            },
      );
}
