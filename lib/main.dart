import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/config/theme.dart';

void main() {
  runApp(const ProviderScope(child: UseUpApp()));
}

class UseUpApp extends StatelessWidget {
  const UseUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UseUp',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(child: Text('Welcome to UseUp')),
      ),
    );
  }
}