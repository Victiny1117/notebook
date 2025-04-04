import 'package:flutter/material.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desarrolladores'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Creado por:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
	    Text(
              'Edwin Rodríguez',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
	    Text(
              'Ziad Rivero',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('E-mails:'), 
	    Text('erodriguez.7957@unimar.edu.ve'), 
	    Text('zrivero.0219@unimar.edu.ve'),
          ],
        ),
      ),
    );
  }
}