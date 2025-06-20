import 'package:flutter/material.dart';
import 'package:ignitor/src/features/developer/widget/developer_screen.dart';

const IconData developerIcon = Icons.data_saver_off_outlined;

class DeveloperButton extends StatelessWidget {
  const DeveloperButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed:
        () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const DeveloperScreen()),
        ),
    icon: const Icon(developerIcon, size: 16),
  );
}
