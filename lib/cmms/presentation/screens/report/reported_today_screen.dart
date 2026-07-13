import 'package:flutter/material.dart';

class ReportedTodayScreen extends StatelessWidget {
  const ReportedTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reported Today'),
      ),
      body: const Center(
        child: Text('Template Page: Reported Today'),
      ),
    );
  }
}
