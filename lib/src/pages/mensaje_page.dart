import 'package:flutter/material.dart';

class MensajePage extends StatelessWidget {
  const MensajePage({super.key});

  @override
  Widget build(BuildContext context) {

    final arg = ModalRoute.of(context)?.settings.arguments ?? 'no-data';
    return Scaffold(

      appBar: AppBar(title: const Text('Mensaje Page'),),
      body:  Center(child: Text(arg.toString())),

    );
  }
}