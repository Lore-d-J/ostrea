import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tulong'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _InfoHeader(
            icon: Icons.help_outline,
            title: 'Paano ka namin matutulungan?',
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          _InfoCard(
            icon: Icons.school_outlined,
            title: 'Mga Modyul',
            text: 'Ang gabay at nilalaman para sa seksyong ito ay ilalagay dito.',
          ),
          _InfoCard(
            icon: Icons.menu_book_outlined,
            title: 'Diksyonaryo',
            text: 'Ang mga paliwanag tungkol sa paggamit ng diksyonaryo ay ilalagay dito.',
          ),
          _InfoCard(
            icon: Icons.contact_support_outlined,
            title: 'Kailangan pa ng tulong?',
            text: 'Magdagdag ng contact details o iba pang support information dito.',
          ),
        ],
      ),
    );
  }
}

class _InfoHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _InfoHeader({required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, size: 36, color: color),
        ),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoCard({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(text),
        ),
      ),
    );
  }
}