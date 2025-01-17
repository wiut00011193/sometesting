import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Text(
          message,
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
