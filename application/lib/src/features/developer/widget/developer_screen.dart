import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/features/developer/widget/developer_button.dart';
import 'package:ui/ui.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});
  static const String name = 'developer';
  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  // ignore: unused_element
  void _push(Widget screen) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(DeveloperScreen.name),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Space.sm(),
          const Text('Developer tools', textAlign: TextAlign.center),
          Space.sm(),
          _Category(
            categoryName: 'core',
            children: [
              _CategoryItem(
                title: 'meta',
                subtitle: 'application meta data',
                onTap: () {},
              ),
            ],
          ),
          const _Category(
            categoryName: 'Data',
            children: [
              // _CategoryItem(
              //   title: 'kv preferences',
              //   subtitle: 'key value preferences store',
              //   onTap: () => _push( KeyValuePreferences),
              // ),
            ],
          ),
          _Category(
            categoryName: 'Analytics',
            children: [
              _CategoryItem(
                title: 'reporter history',
                subtitle: 'show analytics reporter history',
                onTap: () => _push(const DeveloperAnalyticsScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    required this.categoryName,
    required this.children,
    // ignore: unused_element_parameter
    this.isDangerous = false,
  });
  final bool isDangerous;
  final String categoryName;
  final List<_CategoryItem> children;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.coronavirus, color: Colors.amber, size: 20),
                if (isDangerous)
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 18,
                  ),
                Text(categoryName.toUpperCase(), textAlign: TextAlign.center),
                const Icon(Icons.coronavirus, color: Colors.amber, size: 20),
              ],
            ),
          ),
          const Divider(),
          for (final child in children) child,
        ],
      ),
    ),
  );
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
    // ignore: unused_element_parameter
    this.isDangerous = false,
  });
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDangerous;

  //show warning dialog
  // ignore: unused_element
  void _showWarningDialog(
    BuildContext context,
    VoidCallback action, {
    String description =
        'This action is dangerous and may cause data loss or other issues.',
    String title = 'Dangerous action',
    String actionTitle = 'OK',
  }) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  action();
                  Navigator.of(context).pop();
                },

                child: Text(actionTitle),
              ),
            ],
          ),
    ).ignore();
  }

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title.toUpperCase()),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.arrow_forward_ios_rounded),
    leading: Icon(developerIcon, color: isDangerous ? Colors.red : null),
    onTap:
        onTap == null
            ? null
            : isDangerous
            ? () => _showWarningDialog(context, onTap!)
            : onTap,
  );
}
