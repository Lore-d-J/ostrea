import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/services/local_storage_service.dart';
import 'package:ostrea/services/text_to_speech_service.dart';
import 'package:ostrea/localization/app_strings.dart';

class LearningModuleScreen extends StatefulWidget {
  final LearningModule module;

  const LearningModuleScreen({
    super.key,
    required this.module,
  });

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreenState();
}

class _LearningModuleScreenState extends State<LearningModuleScreen> {
  int _currentSection = 0;
  bool _isBookmarked = false;
  bool _isSpeaking = false;
  late PageController _pageController;
  late TextToSpeechService _ttsService;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ttsService = TextToSpeechService();
    _checkBookmarkStatus();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.module.videoAsset != null) {
      _videoController = VideoPlayerController.asset(widget.module.videoAsset!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  void _checkBookmarkStatus() async {
    final isBookmarked = await LocalStorageService.isBookmarked(widget.module.id);
    setState(() {
      _isBookmarked = isBookmarked;
    });
  }

  void _toggleBookmark() async {
    if (_isBookmarked) {
      await LocalStorageService.removeBookmark(widget.module.id);
    } else {
      await LocalStorageService.addBookmark(widget.module.id);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _speakContent(String text) async {
    try {
      await _ttsService.initialize();
      setState(() {
        _isSpeaking = true;
      });
      await _ttsService.speak(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hindi makasalita: $e')),
      );
    }
  }

  void _stopSpeaking() async {
    await _ttsService.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  void _completeModule() async {
    await LocalStorageService.completeModule(widget.module.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapos na ang módulo! Magpatuloy sa pag-aaral!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentSection + 1) / widget.module.contentSections.length,
            minHeight: 4,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentSection = index;
                });
                LocalStorageService.saveModuleProgress(
                  widget.module.id,
                  index,
                );
              },
              itemCount: widget.module.contentSections.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video if available
                      if (widget.module.videoAsset != null && _videoController != null)
                        Container(
                          width: double.infinity,
                          height: 250,
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                VideoPlayer(_videoController!),
                                Positioned.fill(
                                  child: Center(
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.white70,
                                      onPressed: () {
                                        setState(() {
                                          if (_videoController!.value.isPlaying) {
                                            _videoController!.pause();
                                          } else {
                                            _videoController!.play();
                                          }
                                        });
                                      },
                                      child: Icon(
                                        _videoController!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Module image if available
                      if (widget.module.imageAsset != null)
                        Container(
                          width: double.infinity,
                          height: 200,
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.module.imageAsset!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      // Section title
                      Text(
                        'Seksyon ${index + 1}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 12),
                      // TTS Controls
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isSpeaking
                                    ? _stopSpeaking
                                    : () => _speakContent(widget.module.contentSections[index]),
                                icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
                                label: Text(_isSpeaking ? 'Tumitigil' : 'Marinig'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Section content
                      Text(
                        widget.module.contentSections[index],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                      ),
                      SizedBox(height: 24),
                      // Key takeaways box
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          border: Border(
                            left: BorderSide(
                              color: Colors.green,
                              width: 4,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pangunahing Takeaway',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tandaan ang pangunahing konsepto mula sa seksyong ito para sa mas mahusay na pagsasanay sa oyster.',
                              style: TextStyle(
                                color: Colors.green[600],
                              ),
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
          // Navigation buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentSection > 0)
                  ElevatedButton.icon(
                    onPressed: () => _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    icon: Icon(Icons.arrow_back),
                    label: Text(AppStrings.previous),
                  ),
                Spacer(),
                if (_currentSection < widget.module.contentSections.length - 1)
                  ElevatedButton.icon(
                    onPressed: () => _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    label: Text(AppStrings.next),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.arrow_forward),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _completeModule,
                    label: Text(AppStrings.ok),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.check),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    _ttsService.dispose();
    super.dispose();
  }
}
