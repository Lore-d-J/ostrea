import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const List<_TeamMember> _teamMembers = [
    _TeamMember(
      role: 'Technical Adviser',
      imageAsset: 'assets/images/about_technical_adviser.jpg',
      name: 'Dr. Michelle C. Tanega',
    ),
    _TeamMember(
      role: 'Technical Critic',
      imageAsset: 'assets/images/about_technical_critic.png',
      name: 'Ms. Arvel O. Himor',
    ),
    _TeamMember(
      role: 'Developer',
      imageAsset: 'assets/images/about_developer_1.jpg',
      name: 'Janelle A. Antipala',
    ),
    _TeamMember(
      role: 'Developer',
      imageAsset: 'assets/images/about_developer_2.png',
      name: 'John Erol G. Tambal',
    ),
    _TeamMember(
      role: 'Developer',
      imageAsset: 'assets/images/about_developer_3.jpg',
      name: 'Marilyn S. Bujos',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          Text('Tungkol sa App', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          _buildParagraph(context, const [
            TextSpan(
              text: 'Ang Ostrea',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  ' ay isang Android application na ginawa para sa mga nag-aalaga ng talaba. Nagbibigay ito ng mga simpleng aralin, larawan, at gabay tungkol sa pag-aalaga ng talaba.',
            ),
          ]),
          _buildSectionHeading(context, 'Layunin ng Ostrea'),
          _buildParagraph(context, const [
            TextSpan(
              text:
                  'Layunin ng Ostrea na magbigay ng simple at madaling maintindihang kaalaman tungkol sa pag-aalaga ng talaba. Makikita sa app ang mga aralin tungkol sa pag-aalaga ng talaba, mga karaniwang problema, at mga paraan kung paano ito maaalagaan nang tama.',
            ),
          ]),
          _buildSectionHeading(context, 'Para Kanino ang App?'),
          _buildParagraph(context, const [
            TextSpan(text: 'Ang Ostrea ay ginawa para sa mga nag-aalaga ng talaba sa '),
            TextSpan(
              text: 'Timalan Balsahan, Naic, Cavite',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  ', na may layunin na magbigay ng mga useful learning materials na maaaring ma-access nang convenient sa pamamagitan ng isang mobile device.',
            ),
          ]),
          _buildSectionHeading(context, 'Mga Gumawa ng App'),
          Text('Mga Developer ng App', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          ..._teamMembers
              .where((member) => member.role == 'Developer')
              .map((member) => _buildMemberCard(context, member)),
          _buildSectionHeading(context, 'Technical Adviser'),
          _buildMemberCard(context, _teamMembers[0]),
          _buildSectionHeading(context, 'Technical Critic'),
          _buildMemberCard(context, _teamMembers[1]),
          _buildSectionHeading(context, 'Academic Institution'),
          _buildParagraph(context, const [
            TextSpan(
              text: 'Cavite State University - Naic Campus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '\nBachelor of Science in Information Technology'),
          ]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cvsu-naic-logo.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Cavite State University - Naic',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              '© 2026 Ostrea. All Rights Reserved.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildParagraph(BuildContext context, List<TextSpan> children) {
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        children: children,
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, _TeamMember member) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                member.imageAsset,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 92,
                  height: 92,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.18),
                  child: Icon(
                    Icons.person_outline,
                    size: 42,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.role, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    member.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMember {
  final String role;
  final String imageAsset;
  final String name;

  const _TeamMember({
    required this.role,
    required this.imageAsset,
    required this.name,
  });
}
