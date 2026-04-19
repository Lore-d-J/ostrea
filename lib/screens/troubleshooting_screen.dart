import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/services/text_to_speech_service.dart';
import 'package:ostrea/services/local_data_service.dart';
import 'package:ostrea/localization/app_strings.dart';
import 'package:ostrea/screens/dictionary_screen.dart';

class TroubleshootingScreen extends StatefulWidget {
  const TroubleshootingScreen({super.key});

  @override
  State<TroubleshootingScreen> createState() => _TroubleshootingScreenState();
}

class _TroubleshootingScreenState extends State<TroubleshootingScreen> {
  late List<TroubleshootingGuide> guides;
  bool _isLoading = true;
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
    try {
      final guides = await LocalDataService().getTroubleshootingGuides();
      setState(() {
        this.guides = guides;
        _isLoading = false;
      });
    } catch (e) {
      if(!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading guides: $e')),
      );
    }
  }

  List<TroubleshootingGuide> get _filteredGuides {
    if (_selectedSeverity == null || _isLoading) return [];
    return guides.where((g) => g.severity == _selectedSeverity).toList();
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red[600]!;
      case 'medium':
        return Colors.orange[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  String _getSeverityLabel(String severity) {
    switch (severity) {
      case 'high':
        return 'Mataas';
      case 'medium':
        return 'Katamtaman';
      default:
        return 'Mababa';
    }
  }

  void _speakText(String text, String id) async {
    try {
      await _ttsService.initialize();
      setState(() {
        _isSpeakingMap[id] = true;
      });
      await _ttsService.speak(text);
      if(mounted) {
        setState(() => _isSpeakingMap[id] = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSpeakingMap[id] = false);
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
          if(mounted) setState(() {});
        })
        ..addListener(() {
          if(mounted) setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        // use theme's primary color instead of hardcoded green
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset('assets/images/ostreaLogo.png'),
        ),
        title: Text(
          'Troubleshooting Guide',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.book),
            tooltip: 'Diksyonaryo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DictionaryScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter section
                Container(
                  color: Colors.grey[50],
                  padding: EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text('Lahat ng Isyu'),
                          selected: _selectedSeverity == null,
                          selectedColor: Colors.green[200],
                          onSelected: (selected) {
                            setState(() => _selectedSeverity = null);
                          },
                        ),
                        SizedBox(width: 8),
                        FilterChip(
                          label: Text('Mataas na Prioridad'),
                          selected: _selectedSeverity == 'high',
                          selectedColor: Colors.red[200],
                          onSelected: (selected) {
                            setState(() => _selectedSeverity = selected ? 'high' : null);
                          },
                        ),
                        SizedBox(width: 8),
                        FilterChip(
                          label: Text('Katamtamang Prioridad'),
                          selected: _selectedSeverity == 'medium',
                          selectedColor: Colors.orange[200],
                          onSelected: (selected) {
                            setState(() => _selectedSeverity = selected ? 'medium' : null);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Guides list
                Expanded(
                  child: _selectedSeverity != null && _filteredGuides.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Walang nakitang gabay',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: _selectedSeverity == null ? guides.length : _filteredGuides.length,
                          itemBuilder: (context, index) {
                            final guide = _selectedSeverity == null ? guides[index] : _filteredGuides[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _getSeverityColor(guide.severity),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
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
                                    Chip(
                                      label: Text(
                                        _getSeverityLabel(guide.severity),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: _getSeverityColor(guide.severity),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (guide.videoAsset != null && guide.videoAsset!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 16),
                                            child: _buildVideoSection(guide),
                                          ),
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
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
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
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '• ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
      height: 280, // Increased for controls
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Video player
            Expanded(
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  // Play/pause overlay
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
            // Control bar
            Container(
              height: 50,
              color: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Play/Pause button
                  IconButton(
                    icon: Icon(
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      });
                    },
                  ),
                  // Skip backward
                  IconButton(
                    icon: Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () {
                      final current = controller.value.position;
                      final newPosition = current - Duration(seconds: 10);
                      controller.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
                    },
                  ),
                  // Progress bar
                  Expanded(
                    child: Slider(
                      value: controller.value.position.inSeconds.toDouble(),
                      max: controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        controller.seekTo(Duration(seconds: value.toInt()));
                      },
                      activeColor: Colors.green,
                      inactiveColor: Colors.white30,
                    ),
                  ),
                  // Skip forward
                  IconButton(
                    icon: Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () {
                      final current = controller.value.position;
                      final duration = controller.value.duration;
                      final newPosition = current + Duration(seconds: 10);
                      controller.seekTo(newPosition < duration ? newPosition : duration);
                    },
                  ),
                  // Time display
                  Text(
                    '${_formatDuration(controller.value.position)} / ${_formatDuration(controller.value.duration)}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
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
