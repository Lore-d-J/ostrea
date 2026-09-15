import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Tulong'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Text(
            'Paano gamitin ang Ostrea',
            style: TextStyle(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Maikling gabay sa mga pangunahing screen at gamit ng app.',
            style: TextStyle(fontSize: 16, color: Color(0xFF5F6B76)),
          ),
          const SizedBox(height: 24),
          _GuideSection(
            title: 'A. Screen ng mga Modyul',
            icon: Icons.school_outlined,
            color: primaryColor,
            steps: [
              const _GuideStep(
                number: '1',
                title: 'Pumili ng Modyul',
                description: 'Pumili ng modyul sa listahan para magsimula.',
                imageAsset: 'assets/images/A.1.png',
              ),
              const _GuideStep(
                number: '2',
                title: 'Gamitin ang Audio button',
                description:
                    'Pindutin ang audio button para mapakinggan ang paliwanag sa kasalukuyang bahagi.',
                imageAsset: 'assets/images/A.2.png',
              ),
              const _GuideStep(
                number: '3',
                title: 'Pumunta sa susunod na bahagi',
                description:
                    'Pindutin ang button para pumunta sa susunod na bahagi ng modyul.',
                imageAsset: 'assets/images/A.3.png',
              ),
              const _GuideStep(
                number: '4',
                title: 'Tapusin ang modyul',
                description:
                    'Pindutin ang Done pagkatapos ng lahat ng bahagi. Maise-save ang iyong progreso.',
                imageAsset: 'assets/images/A.4.png',
              ),
              const _GuideStep(
                number: '5',
                title: 'Pumili ng ibang modyul',
                description:
                    'Bumalik sa screen ng mga modyul at pumili ng iba para magpatuloy.',
              ),
            ],
          ),
          _GuideSection(
            title: 'B. Screen ng Pag-aayos ng Problema',
            icon: Icons.build_outlined,
            color: primaryColor,
            steps: [
              const _GuideStep(
                number: '1',
                title: 'Maghanap ng solusyon',
                description:
                    'Tingnan ang mga gabay, maghanap ng problema, o pumili ayon sa bigat ng problema.',
              ),
              const _GuideStep(
                number: '2',
                title: 'Buksan ang gabay',
                description:
                    'Pindutin ang gabay para makita ang mga hakbang, larawan, at audio na paliwanag.',
              ),
            ],
          ),
          _GuideSection(
            title: 'C. Screen ng Pagtukoy ng Pagbabago sa Kulay',
            icon: Icons.image_search_outlined,
            color: primaryColor,
            steps: [
              const _GuideStep(
                number: '1',
                title: 'Kumuha o mag-upload ng larawan',
                description:
                    'Kumuha ng bagong larawan o pumili mula sa gallery.',
                imageAsset: 'assets/images/C.1.png',
              ),
              const _GuideStep(
                number: '2',
                title: 'Pindutin ang Scan o Suriin',
                description:
                    'Tingnan ang larawan, pagkatapos ay pindutin ang Suriin.',
                imageAsset: 'assets/images/C.2.png',
              ),
              const _GuideStep(
                number: '3',
                title: 'Tingnan ang resulta',
                description:
                    'Basahin ang nakita na pagbabago sa kulay at ang payo sa result card.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_GuideStep> steps;

  const _GuideSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps,
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final String? imageLabel;
  final String? imageAsset;

  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
    this.imageLabel,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Color(0xFF5F6B76),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (imageLabel != null || imageAsset != null) ...[
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(minHeight: 150),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: imageAsset != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(imageAsset!, fit: BoxFit.contain),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: color,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          imageLabel!,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
