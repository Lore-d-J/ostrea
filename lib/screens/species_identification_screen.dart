import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ostrea/services/species_identification_service.dart';
import 'package:ostrea/localization/app_strings.dart';

class SpeciesIdentificationScreen extends StatefulWidget {
  const SpeciesIdentificationScreen({super.key});

  @override
  State<SpeciesIdentificationScreen> createState() =>
      _SpeciesIdentificationScreenState();
}

class _SpeciesIdentificationScreenState extends State<SpeciesIdentificationScreen> {
  final SpeciesIdentificationService _service =
      SpeciesIdentificationService();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  Map<String, dynamic>? _identificationResult;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service.initialize();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _identificationResult = null;
          _errorMessage = null;
        });
        _identifySpecies();
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${AppStrings.failedToPickImage}: $e';
      });
    }
  }

  Future<void> _identifySpecies() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final imageBytes = await _selectedImage!.readAsBytes();
      final result = await _service.identifySpecies(imageBytes);

      setState(() {
        _identificationResult = result;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${AppStrings.identificationFailed}: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Instructions
            Container(
              color: Colors.green[50],
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.speciesTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppStrings.speciesInstructions,
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.goodLighting,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Image preview or placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 12),
                            Text(
                              AppStrings.noImageSelected,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 20),
            // Image selection buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text(AppStrings.takePhoto),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text(AppStrings.uploadFromGallery),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Processing indicator
            if (_isProcessing)
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('${AppStrings.loading}..'),
                  ],
                ),
              ),
            // Error message
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ),
            // Results
            if (_identificationResult != null && !_isProcessing)
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main result
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        border: Border.all(color: Colors.green[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.identifyResult,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _identificationResult!['species'],
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.green[800],
                                ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${AppStrings.confidence}: ',
                                style: TextStyle(
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                '${_identificationResult!['confidence']}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Alternative predictions
                    Text(
                      AppStrings.allPredictions,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: (_identificationResult!['allPredictions']
                              as List<Map<String, dynamic>>)
                          .skip(1)
                          .map((pred) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pred['label'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        '${pred['confidence']}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
