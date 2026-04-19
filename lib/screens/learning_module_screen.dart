import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/services/local_storage_service.dart';
import 'package:ostrea/services/text_to_speech_service.dart';
import 'package:ostrea/localization/app_strings.dart';
import 'package:ostrea/screens/dictionary_screen.dart';

class LearningModuleScreen extends StatefulWidget {
  final LearningModule module;

  const LearningModuleScreen({super.key, required this.module});

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreenState();
}

class _LearningModuleScreenState extends State<LearningModuleScreen> {
  int _currentSection = 0;
  bool _isSpeaking = false;
  late PageController _pageController;
  late TextToSpeechService _ttsService;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ttsService = TextToSpeechService();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.module.videoAsset != null) {
      _videoController = VideoPlayerController.asset(widget.module.videoAsset!)
        ..initialize().then((_) {
          setState(() {});
        })
        ..addListener(() {
          setState(() {});
        });
    }
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hindi makasalita: $e')));
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
        SnackBar(
          content: Text('Tapos na ang módulo! Magpatuloy sa pag-aaral!'),
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildVideoPlayer() {
    if (widget.module.videoAsset == null || _videoController == null) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 280,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
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
            Container(
              height: 50,
              color: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () {
                      final current = _videoController!.value.position;
                      final newPosition = current - Duration(seconds: 10);
                      _videoController!.seekTo(
                        newPosition > Duration.zero
                            ? newPosition
                            : Duration.zero,
                      );
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _videoController!.value.position.inSeconds
                          .toDouble(),
                      max: _videoController!.value.duration.inSeconds
                          .toDouble(),
                      onChanged: (value) {
                        _videoController!.seekTo(
                          Duration(seconds: value.toInt()),
                        );
                      },
                      activeColor: Colors.green,
                      inactiveColor: Colors.white30,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () {
                      final current = _videoController!.value.position;
                      final duration = _videoController!.value.duration;
                      final newPosition = current + Duration(seconds: 10);
                      _videoController!.seekTo(
                        newPosition < duration ? newPosition : duration,
                      );
                    },
                  ),
                  Text(
                    '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _stopSpeaking();
            _videoController?.pause();
            Navigator.pop(context);
          },
        ),
        title: Text(widget.module.title),
        elevation: 4,
        shadowColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.3),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${_currentSection + 1} / ${widget.module.contentSections.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value:
                          (_currentSection + 1) /
                          widget.module.contentSections.length,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
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
                itemBuilder: (context, index) => _buildLessonPage(index),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentSection > 0)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        icon: Icon(Icons.arrow_back),
                        label: Text(AppStrings.previous),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  if (_currentSection > 0 &&
                      _currentSection <
                          widget.module.contentSections.length - 1)
                    SizedBox(width: 12),
                  if (_currentSection <
                      widget.module.contentSections.length - 1)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        label: Text(AppStrings.next),
                        iconAlignment: IconAlignment.end,
                        icon: Icon(Icons.arrow_forward),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  if (_currentSection >=
                      widget.module.contentSections.length - 1)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _completeModule,
                        label: Text(AppStrings.ok),
                        iconAlignment: IconAlignment.end,
                        icon: Icon(Icons.check),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
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

  Widget _buildLessonPage(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0) _buildVideoPlayer(),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                ),
              ),
              child: Text(
                'Seksyon ${index + 1}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSpeaking
                          ? _stopSpeaking
                          : () => _speakContent(
                              widget.module.contentSections[index],
                            ),
                      icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
                      label: Text(_isSpeaking ? 'Tumitigil' : 'Marinig'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSpeaking
                            ? Colors.red[400]
                            : Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.module.contentSections[index],
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border(left: BorderSide(color: Colors.green, width: 4)),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Pangunahing Punto',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tandaan ang pangunahing punto mula sa seksyong ito para sa mas mahusay na pagsasanay sa oyster.',
                    style: TextStyle(color: Colors.green[600]),
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
    _pageController.dispose();
    _stopSpeaking();
    _videoController?.pause();
    _videoController?.dispose();
    _ttsService.dispose();
    super.dispose();
  }
}
