import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Haptics
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/screens/learning_module_screen.dart';
import 'package:ostrea/services/local_storage_service.dart';
import 'package:ostrea/services/local_data_service.dart';
import 'package:ostrea/screens/dictionary_screen.dart';

class LearningModulesScreen extends StatefulWidget {
  const LearningModulesScreen({super.key});

  @override
  State<LearningModulesScreen> createState() => _LearningModulesScreenState();
}

class _LearningModulesScreenState extends State<LearningModulesScreen> {
  List<LearningModule> modules = [];
  List<String> _completedModules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    await Future.wait([_loadModules(), _loadProgress()]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadModules() async {
    final fetchedModules = await LocalDataService().getLearningModules();
    modules = fetchedModules;
  }

  Future<void> _loadProgress() async {
    final completed = await LocalStorageService.getCompletedModules();
    setState(() {
      _completedModules = completed;
    });
  }

  void _navigateToModule(LearningModule module) {
    HapticFeedback.lightImpact(); // Subtle vibration for Android
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningModuleScreen(module: module),
      ),
    ).then((_) => _loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    // Custom aquatic colors
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
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Entry animation logic
                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: _buildModuleCard(modules[index], oceanDeep),
                              ),
                            );
                          },
                        );
                      },
                      childCount: modules.length,
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
          'Mga Modulo',
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
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.auto_stories, color: Colors.white),
            tooltip: 'Diksyonaryo',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DictionaryScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(LearningModule module, Color primaryColor) {
    final bool isCompleted = _completedModules.contains(module.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToModule(module),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Stack
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green.withOpacity(0.1) : primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      isCompleted ? Icons.verified : Icons.waves,
                      color: isCompleted ? Colors.green : primaryColor,
                      size: 30,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Text Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        module.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildSmallTag(Icons.menu_book, "${module.contentSections.length}", Colors.orange),
                          const SizedBox(width: 12),
                          if (isCompleted)
                            _buildSmallTag(Icons.check_circle, "Tapos na", Colors.green)
                          else
                            _buildSmallTag(Icons.arrow_forward, "Simulan", primaryColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallTag(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}