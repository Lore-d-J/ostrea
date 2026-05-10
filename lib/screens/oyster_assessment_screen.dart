import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/prediction_result.dart';
import '../services/image_classifier_service.dart';
import '../utils/recommendation_helper.dart';
import '../widgets/result_card.dart';
import '../widgets/recommendation_card.dart';

class OysterAssessmentScreen extends StatefulWidget {
  const OysterAssessmentScreen({super.key});

  @override
  State<OysterAssessmentScreen> createState() => _OysterAssessmentScreenState();
}

class _OysterAssessmentScreenState extends State<OysterAssessmentScreen> {
  final _picker = ImagePicker();
  final _classifier = ImageClassifierService();

  File? _selectedImage;
  PredictionResult? _prediction;
  Recommendation? _recommendation;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _classifier.initialize();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
        _prediction = null;
        _recommendation = null;
        _errorMessage = null;
      });

      await _analyzeImage();
    } catch (error) {
      setState(() {
        _errorMessage = 'Unable to load image. Please try again.';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final bytes = await _selectedImage!.readAsBytes();
      final prediction = await _classifier.classifyImage(bytes);
      final recommendation = getRecommendation(prediction.label);

      setState(() {
        _prediction = prediction;
        _recommendation = recommendation;
        _isProcessing = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Analysis failed. Please try another image.';
        _isProcessing = false;
      });
    }
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF3F7FB);
    const primary = Color(0xFF006D77);
    const accent = Color(0xFF83C5BE);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Oyster Discoloration Assessment'),
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AI-Assisted Oyster Assessment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Capture or upload an oyster image to assess discoloration and receive a recommendation.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onPressed: () => _pickImage(ImageSource.camera),
                    color: primary,
                  ),
                  const SizedBox(width: 12),
                  _buildSourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: () => _pickImage(ImageSource.gallery),
                    color: accent,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildImagePreview(context),
              const SizedBox(height: 20),
              if (_isProcessing) _buildLoadingCard(primary),
              if (_errorMessage != null) _buildErrorMessage(context),
              if (_prediction != null && _recommendation != null) ...[
                ResultCard(
                  prediction: _prediction!,
                  recommendation: _recommendation!,
                ),
                const SizedBox(height: 18),
                RecommendationCard(recommendation: _recommendation!),
              ],
              const SizedBox(height: 24),
              _buildDisclaimerCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    if (_selectedImage == null) {
      return Container(
        height: 240,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No image selected yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the buttons above to capture or upload an oyster photo.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.file(_selectedImage!, height: 280, fit: BoxFit.cover),
    );
  }

  Widget _buildLoadingCard(Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularProgressIndicator(color: accentColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Analyzing oyster discoloration…',
              style: TextStyle(
                color: accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade700)),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Results are AI-assisted recommendations only.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
