import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/services/text_to_speech_service.dart';
import 'package:ostrea/services/local_data_service.dart';
import 'package:ostrea/localization/app_strings.dart';

class TroubleshootingScreen extends StatefulWidget {
  const TroubleshootingScreen({super.key});

  @override
  State<TroubleshootingScreen> createState() => _TroubleshootingScreenState();
}

class _TroubleshootingScreenState extends State<TroubleshootingScreen> {
  late List<TroubleshootingGuide> guides;
  String? _selectedSeverity;
  final Map<String, VideoPlayerController?> _videoControllers = {};
  final Map<String, bool> _isSpeakingMap = {};
  late TextToSpeechService _ttsService;

  @override
  void initState() {
    super.initState();
    _loadGuides();
    _ttsService = TextToSpeechService();
  }

  void _loadGuides() async {
    final guides = await LocalDataService().getTroubleshootingGuides();
    setState(() {
      this.guides = guides;
    });
  }

  List<TroubleshootingGuide> get _filteredGuides {
    if (_selectedSeverity == null) return guides;
    return guides.where((g) => g.severity == _selectedSeverity).toList();
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _speakText(String text, String id) async {
    try {
      await _ttsService.initialize();
      setState(() {
        _isSpeakingMap[id] = true;
      });
      await _ttsService.speak(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hindi makasalita: $e')),
      );
    }
  }

  void _stopSpeaking(String id) async {
    await _ttsService.stop();
    setState(() {
      _isSpeakingMap[id] = false;
    });
  }

  void _initializeVideoController(String guideId, String videoAsset) {
    if (!_videoControllers.containsKey(guideId) && videoAsset.isNotEmpty) {
      _videoControllers[guideId] = VideoPlayerController.asset(videoAsset)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text('Lahat ng Isyu'),
                    selected: _selectedSeverity == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSeverity = null;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Mataas na Prioridad'),
                    selected: _selectedSeverity == 'high',
                    onSelected: (selected) {
                      setState(() {
                        _selectedSeverity = selected ? 'high' : null;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Katamtamang Prioridad'),
                    selected: _selectedSeverity == 'medium',
                    onSelected: (selected) {
                      setState(() {
                        _selectedSeverity = selected ? 'medium' : null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // List of guides
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _filteredGuides.length,
              itemBuilder: (context, index) {
                final guide = _filteredGuides[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          color: _getSeverityColor(guide.severity),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                guide.problem,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Video if available
                            if (guide.videoAsset != null && guide.videoAsset!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: _buildVideoSection(guide),
                              ),
                            // Problem section
                            Text(
                              'Problema',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              guide.problem,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 12),
                            // TTS Button for problem and cause
                            ElevatedButton.icon(
                              onPressed: (_isSpeakingMap[guide.id] ?? false)
                                  ? () => _stopSpeaking(guide.id)
                                  : () => _speakText(
                                      '${guide.problem}. ${guide.cause}',
                                      guide.id),
                              icon: Icon((_isSpeakingMap[guide.id] ?? false)
                                  ? Icons.stop
                                  : Icons.volume_up),
                              label: Text((_isSpeakingMap[guide.id] ?? false)
                                  ? 'Tumitigil'
                                  : 'Marinig'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12),
                            // Cause section
                            Text(
                              AppStrings.cause,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              guide.cause,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 16),
                            // Solutions section
                            Text(
                              AppStrings.solutions,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: guide.solutions
                                  .map((solution) => Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '• ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(solution),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(TroubleshootingGuide guide) {
    if (guide.videoAsset == null || guide.videoAsset!.isEmpty) {
      return SizedBox.shrink();
    }

    _initializeVideoController(guide.id, guide.videoAsset!);
    final controller = _videoControllers[guide.id];

    if (controller == null || !controller.value.isInitialized) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            VideoPlayer(controller),
            Positioned.fill(
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.white70,
                  onPressed: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  child: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller?.dispose();
    }
    _ttsService.dispose();
    super.dispose();
  }
}
