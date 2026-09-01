import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ostrea/services/image_classifier_service.dart';
import 'package:ostrea/models/prediction_result.dart';
import 'package:ostrea/utils/recommendation_helper.dart';
import 'package:ostrea/widgets/result_card.dart';
import 'package:ostrea/widgets/recommendation_card.dart';
import 'package:ostrea/localization/app_strings.dart';

class DiscolorationIdentificationScreen extends StatefulWidget {
  const DiscolorationIdentificationScreen({super.key});

  @override
  State<DiscolorationIdentificationScreen> createState() =>
      _DiscolorationIdentificationScreenState();
}

class _DiscolorationIdentificationScreenState
    extends State<DiscolorationIdentificationScreen> {
  final ImageClassifierService _classifier = ImageClassifierService();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  PredictionResult? _prediction;
  bool _isProcessing = false;
  String? _errorMessage;
  bool _showAnalyzeButton = false;

  @override
  void initState() {
    super.initState();
    _classifier.initialize();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _prediction = null;
          _errorMessage = null;
          _showAnalyzeButton = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Hindi makapili ng larawan: $e';
      });
    }
  }

  Future<void> _identifyDisease() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final imageBytes = await _selectedImage!.readAsBytes();
      final prediction = await _classifier.classifyImage(imageBytes);

      setState(() {
        _prediction = prediction;
        _isProcessing = false;
        _showAnalyzeButton = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Hindi ma-suri ang larawan: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom aquatic colors to match learning modules
    final Color oceanDeep = const Color(0xFF006D77);
    final Color oceanLight = const Color(0xFF83C5BE);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, oceanDeep),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // Instructions
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: oceanDeep,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pagsusuri sa Kulay ng Talaba',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mag-upload o kumuha ng larawan ng talaba para makita kung may pagbabago sa kulay at makakuha ng payo.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildImagePickerButton(
                          icon: Icons.camera_alt,
                          label: 'Kumuha ng larawan',
                          onPressed: () => _pickImage(ImageSource.camera),
                          color: oceanDeep,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImagePickerButton(
                          icon: Icons.photo_library,
                          label: 'Mga larawan',
                          onPressed: () => _pickImage(ImageSource.gallery),
                          color: oceanLight,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: oceanDeep.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tips_and_updates_rounded, color: oceanDeep),
                            const SizedBox(width: 8),
                            Text(
                              'Halimbawa ng larawan na kunin',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: oceanDeep,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/oyster-meat.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kunin ang larawan ng laman ng talaba. Ilagay lang ang isa sa isang shot at tiyaking malinaw ang kulay at bahagi ng talaba.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Image display area
                  if (_selectedImage != null) ...[
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: oceanDeep.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Walang napiling larawan',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pumili ng larawan para suriin ang kulay ng talaba',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_selectedImage != null && _showAnalyzeButton) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                                _prediction = null;
                                _errorMessage = null;
                                _showAnalyzeButton = false;
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Kumuha ulit'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: oceanDeep),
                              foregroundColor: oceanDeep,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _selectedImage == null ? null : _identifyDisease,
                            icon: const Icon(Icons.analytics),
                            label: const Text('Suriin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: oceanDeep,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (_isProcessing) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: oceanDeep.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: oceanDeep),
                          const SizedBox(height: 12),
                          Text(
                            'Naglo-load...',
                            style: TextStyle(
                              color: oceanDeep,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Results
                  if (_prediction != null) ...[
                    const SizedBox(height: 20),
                    ResultCard(
                      prediction: _prediction!,
                      recommendation: Recommendation(
                        warningLevel: _prediction!.label,
                        message: _prediction!.message.isNotEmpty
                            ? _prediction!.message
                            : 'Handa na ang pagsusuri.',
                        badgeColor: _prediction!.label.toLowerCase().contains('normal')
                            ? const Color(0xFF2E7D32)
                            : _prediction!.label.toLowerCase().contains('yellow')
                                ? const Color(0xFFF9A825)
                                : _prediction!.label.toLowerCase().contains('green')
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF546E7A),
                      ),
                    ),
                    const SizedBox(height: 18),
                    RecommendationCard(
                      recommendation: Recommendation(
                        warningLevel: _prediction!.label,
                        message: _prediction!.description.isNotEmpty
                            ? _prediction!.description
                            : 'Handa na ang pagsusuri.',
                        badgeColor: _prediction!.label.toLowerCase().contains('normal')
                            ? const Color(0xFF2E7D32)
                            : _prediction!.label.toLowerCase().contains('yellow')
                                ? const Color(0xFFF9A825)
                                : _prediction!.label.toLowerCase().contains('green')
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF546E7A),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[600],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
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
        title: Text(
          'Pagsusuri sa Kulay ng Talaba',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.white,
          ),
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
                child: Icon(
                  Icons.water,
                  size: 200,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
