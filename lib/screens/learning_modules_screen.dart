import 'package:flutter/material.dart';
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
  // bookmarks removed

  @override
  void initState() {
    super.initState();
    _loadModules();
    _loadProgress();
  }

  void _loadModules() async {
    final modules = await LocalDataService().getLearningModules();
    setState(() {
      this.modules = modules;
      _isLoading = false;
    });
  }

  void _loadProgress() async {
    final completed = await LocalStorageService.getCompletedModules();
    setState(() {
      _completedModules = completed;
    });
  }

  void _navigateToModule(LearningModule module) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningModuleScreen(module: module),
      ),
    ).then((_) {
      _loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset('assets/images/ostreaLogo.png'),
        ),
        title: Text('Mga Módulo sa Pagkatuto'),
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
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final isCompleted = _completedModules.contains(module.id);

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 6,
            shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: InkWell(
                onTap: () => _navigateToModule(module),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.school,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  module.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[700],
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green[600],
                                size: 24,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.article,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${module.contentSections.length} seksyon',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.play_circle_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Simulan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
