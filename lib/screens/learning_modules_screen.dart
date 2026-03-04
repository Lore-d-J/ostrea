import 'package:flutter/material.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/screens/learning_module_screen.dart';
import 'package:ostrea/services/local_storage_service.dart';
import 'package:ostrea/services/local_data_service.dart';

class LearningModulesScreen extends StatefulWidget {
  const LearningModulesScreen({super.key});

  @override
  State<LearningModulesScreen> createState() => _LearningModulesScreenState();
}

class _LearningModulesScreenState extends State<LearningModulesScreen> {
  late List<LearningModule> modules;
  List<String> _completedModules = [];
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
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final isCompleted = _completedModules.contains(module.id);

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _navigateToModule(module),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
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
                                    ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                module.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isCompleted)
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${module.contentSections.length} seksyon',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
