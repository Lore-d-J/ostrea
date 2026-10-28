import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tungkol sa Amin'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: primaryColor.withValues(alpha: 0.12),
            child: Icon(Icons.water, size: 46, color: primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Ostrea',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Impormasyon tungkol sa app at sa mga bumuo nito ay ilalagay dito.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tungkol sa app', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  const Text('Ang paglalarawan, layunin, at bersyon ng app ay ilalagay sa seksyong ito.'),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ang aming grupo', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  const Text('Mga pangalan, organisasyon, at iba pang pagkilala ay maaaring ilagay dito.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}