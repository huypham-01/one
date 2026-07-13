import 'package:flutter/material.dart';

class FixedTodayScreen extends StatelessWidget {
  const FixedTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Today'),
      ),
      body: const Center(
        child: Text('Template Page: Fixed Today'),
      ),
    );
  }
}
