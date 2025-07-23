import 'package:analytics/analytics.dart';
import 'package:analytics/src/event/analytics_event_history_entry.dart';
import 'package:analytics/src/widget/json_beutifier.dart';
import 'package:flutter/material.dart';


class DeveloperAnalyticsScreen extends StatelessWidget {
  const DeveloperAnalyticsScreen({super.key});

  void _showWarningClearDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear Analytics History?'),
          content: const Text('Are you sure you want to clear the analytics history?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                AnalyticsEventHistory.instance.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Clear History'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Analytics History (${AnalyticsEventHistory.instance.eventCounter})'),
          actions: [
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: AnalyticsEventHistory.isEnabled
                  ? 'Analytics is currently sending events'
                  : 'Analytics is not sending events',
              child: Icon(AnalyticsEventHistory.isEnabled ? Icons.check_circle : Icons.cancel,
                  color: AnalyticsEventHistory.isEnabled ? Colors.green : Colors.red),
            ),
            IconButton(icon: const Icon(Icons.delete), onPressed: () => _showWarningClearDialog(context)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<AnalyticsEventHistoryEntry>>(
                initialData: AnalyticsEventHistory.instance.events,
                stream: AnalyticsEventHistory.instance.eventStream,
                builder: (context, snapshot) {
                  final events = snapshot.data ?? [];

                  if (events.isEmpty) {
                    return const Center(child: Text('No events'));
                  }

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];

                      return ExpansionTile(
                        showTrailingIcon: event.event.hasParameters,
                        title: Text(
                          '${event.index}. ${event.event.eventCategory}_${event.event.eventName}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Text('${event.reporterType} (from observer: ${event.eventFromObserver})'),
                        children: [
                          if (event.event.hasParameters)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GenericJsonBeautifier(
                                json: null,
                                map: event.event.parameters,
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Без параметров'),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
}
