import 'package:flutter/material.dart';
import 'package:ostrea/services/localization_service.dart';
import 'package:ostrea/localization/app_strings.dart';
import 'package:ostrea/localization/app_strings_en.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late LocalizationService _localizationService;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _localizationService = LocalizationService();
    _selectedLanguage = _localizationService.currentLanguage;
  }

  void _changeLanguage(String languageCode) async {
    await _localizationService.setLanguage(languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });
    widget.onLanguageChanged();
  }

  @override
  Widget build(BuildContext context) {
    final isTl = _selectedLanguage == 'tl';
    final title = isTl ? AppStrings.titleSettings : AppStringsEn.titleSettings;
    final appSettings = isTl ? AppStrings.appSettings : AppStringsEn.appSettings;
    final language = isTl ? AppStrings.language : AppStringsEn.language;
    final currentLanguage = isTl ? AppStrings.currentLanguage : AppStringsEn.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Settings Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appSettings,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16),
                  // Language Selection Card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            currentLanguage,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Language Options
                          Column(
                            children: [
                              _buildLanguageOption(
                                'English',
                                'en',
                                _selectedLanguage == 'en',
                              ),
                              SizedBox(height: 12),
                              _buildLanguageOption(
                                'Tagalog',
                                'tl',
                                _selectedLanguage == 'tl',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Info Box
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.blue[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTl ? 'Impormasyon' : 'Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          isTl
                              ? 'Ang pagbabago ng wika ay aayon sa buong aplikasyon at sa text-to-speech feature.'
                              : 'Changing the language will apply to the entire app and the text-to-speech feature.',
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ],
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

  Widget _buildLanguageOption(String displayName, String code, bool isSelected) {
    return GestureDetector(
      onTap: () => _changeLanguage(code),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.green[50] : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                  color: isSelected ? Colors.green[700] : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
