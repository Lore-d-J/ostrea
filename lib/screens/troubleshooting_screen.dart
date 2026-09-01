import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/services/audio_playback_service.dart';
import 'package:ostrea/services/local_data_service.dart';
import 'package:ostrea/localization/app_strings.dart';
import 'package:ostrea/screens/dictionary_screen.dart';
import 'package:ostrea/widgets/audio_action_button.dart';

class TroubleshootingScreen extends StatefulWidget {
  const TroubleshootingScreen({super.key});

  @override
  State<TroubleshootingScreen> createState() => _TroubleshootingScreenState();
}

class _TroubleshootingScreenState extends State<TroubleshootingScreen> {
  late List<TroubleshootingGuide> guides;
  List<TroubleshootingGuide> _filteredGuidesList = [];
  bool _isLoading = true;
  String? _selectedSeverity;
  String _searchQuery = "";
  
  final Map<String, bool> _isSpeakingMap = {};
  late AudioPlaybackService _audioService;
  late StreamSubscription<bool> _audioPlaybackSubscription;

  @override
  void initState() {
    super.initState();
    _loadGuides();
    _audioService = AudioPlaybackService();
    _audioPlaybackSubscription = _audioService.playingStream.listen((isPlaying) {
      if (!mounted) return;
      if (!isPlaying) {
        setState(() {
          _isSpeakingMap.updateAll((key, value) => false);
        });
      }
    });
  }

  void _loadGuides() async {
    try {
      final loadedGuides = await LocalDataService().getTroubleshootingGuides();
      if (!mounted) return;
      setState(() {
        guides = loadedGuides;
        _filteredGuidesList = loadedGuides;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredGuidesList = guides.where((guide) {
        final matchesSeverity = _selectedSeverity == null || guide.severity == _selectedSeverity;
        final matchesSearch = guide.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                             guide.problem.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesSeverity && matchesSearch;
      }).toList();
    });
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high': return const Color(0xFFD32F2F); // Red
      case 'medium': return const Color(0xFFF57C00); // Orange
      default: return const Color(0xFF388E3C); // Green
    }
  }

  String _getSeverityLabel(String severity) {
    switch (severity) {
      case 'high': return 'Mataas';
      case 'medium': return 'Katamtaman';
      default: return 'Mababa';
    }
  }

  void _playGuideAudio(String guideId) async {
    setState(() => _isSpeakingMap[guideId] = true);
    final success = await _audioService.playGuide(guideId);
    if (!success && mounted) {
      setState(() => _isSpeakingMap[guideId] = false);
      final guideNum = guideId.replaceAll(RegExp(r'\D'), '') ?? guideId;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Place MP3: assets/audio/guides/ttsTroubleshoot${guideNum}.mp3',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom aquatic colors to match learning modules
    final Color oceanDeep = const Color(0xFF006D77);
    final Color oceanLight = const Color(0xFF83C5BE);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: oceanDeep))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, oceanDeep),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildHeader(oceanDeep, oceanLight),
                      _buildFilterSection(oceanDeep, oceanLight),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: _filteredGuidesList.isEmpty
                      ? SliverToBoxAdapter(child: _buildEmptyState())
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return TweenAnimationBuilder(
                                duration: Duration(milliseconds: 400 + (index * 100)),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: _buildGuideCard(_filteredGuidesList[index], oceanDeep),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: _filteredGuidesList.length,
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Color primaryColor) {
    return SliverAppBar(
      expandedHeight: 48.0,
      toolbarHeight: 48.0,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsetsDirectional.only(start: 20, bottom: 16),
        title: const Text(
          'Gabay sa Problema',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, const Color(0xFF004D40)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -20,
                child: Icon(Icons.water, size: 200, color: Colors.white.withOpacity(0.05)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.book_outlined, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DictionaryScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Color primaryColor, Color accentColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: TextField(
        onChanged: (val) {
          _searchQuery = val;
          _applyFilters();
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: primaryColor),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilterSection(Color primaryColor, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _filterChip(null, 'Lahat'),
            _filterChip('high', 'Mataas'),
            _filterChip('medium', 'Katamtaman'),
            _filterChip('low', 'Mababa'),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String? severity, String label) {
    final isSelected = _selectedSeverity == severity;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        )),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSeverity = selected ? severity : null;
            _applyFilters();
          });
        },
        backgroundColor: Colors.white,
        selectedColor: theme.colorScheme.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildGuideCard(TroubleshootingGuide guide, Color primaryColor) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: _getSeverityColor(guide.severity).withOpacity(0.1),
            child: Icon(Icons.warning_rounded, color: _getSeverityColor(guide.severity)),
          ),
          title: Text(
            guide.title, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142))
          ),
          subtitle: Text(
            _getSeverityLabel(guide.severity),
            style: TextStyle(color: _getSeverityColor(guide.severity), fontWeight: FontWeight.w600, fontSize: 13),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ano ang problema?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(guide.problem, style: TextStyle(color: Colors.grey[700], height: 1.4)),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AudioActionButton(
                          isPlaying: _isSpeakingMap[guide.id] ?? false,
                          onPressed: (_isSpeakingMap[guide.id] ?? false)
                              ? () => _audioService.stop().then((_) => setState(() => _isSpeakingMap[guide.id] = false))
                              : () => _playGuideAudio(guide.id),
                          playingLabel: 'Itigil',
                          stoppedLabel: 'Pakinggan',
                          activeColor: Colors.red,
                          inactiveColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  
                  Text(AppStrings.cause, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(guide.cause, style: TextStyle(color: Colors.grey[700])),
                  
                  const SizedBox(height: 16),
                  Text(AppStrings.solutions, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF388E3C))),
                  const SizedBox(height: 8),
                  ...guide.solutions.map((s) => _buildSolutionItem(s)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF388E3C)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.3))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Walang nakitang gabay.', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlaybackSubscription.cancel();
    _audioService.dispose();
    super.dispose();
  }
}