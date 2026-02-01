# OSTREA - Offline-First E-Learning App for Oyster Farming

A beginner-friendly mobile app for learning and managing oyster farming operations. Built with Flutter, fully offline-capable, and featuring ML-powered oyster species identification.

## Features

### 1. **Learning Modules** 📚
Comprehensive guides covering:
- Introduction to Oyster Farming
- Water Quality Management
- Nutrition and Feeding
- Disease Prevention and Management
- Spat Collection and Seed Production
- Growth Optimization and Harvesting

**Capabilities:**
- Multi-section content with progress tracking
- Bookmarking for quick reference
- Offline access to all materials
- Simple, beginner-friendly language

### 2. **Troubleshooting Guides** 🔧
Solutions for 6+ common oyster farming problems:
- Shell Disease
- Excessive Algae Growth
- High Oyster Mortality
- Slow Growth Rate
- Parasitic Infections
- Poor Spat Settlement

**Features:**
- Severity-based filtering (High/Medium/Low priority)
- Detailed causes and solutions
- Expandable guide cards
- Offline reference database

### 3. **Species Identification** 🔬
ML-powered oyster species identifier using TensorFlow Lite:
- **3 major species supported:**
  - Eastern Oyster (Crassostrea virginica)
  - Pacific Oyster (Crassostrea gigas)
  - Mangrove Oyster (Crassostrea iredalei)
- **Identification features:**
  - Shell and meat classification
  - Confidence scoring
  - Alternative predictions
  - Camera or gallery photo input

### 4. **Local Storage** 💾
Offline-first approach with local persistence:
- Module progress tracking
- Bookmarked content
- Completed modules tracking
- No internet required

## Tech Stack

- **Framework:** Flutter (Dart)
- **UI:** Material Design 3
- **ML:** TensorFlow Lite (image classification)
- **Storage:** SharedPreferences (local)
- **Image Processing:** image package
- **Camera/Gallery:** image_picker
- **Video Support:** video_player (ready for future integration)

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── theme/
│   └── app_theme.dart                 # Material 3 theme configuration
├── models/
│   └── learning_module.dart           # Data models
├── services/
│   ├── local_storage_service.dart     # Local persistence
│   └── species_identification_service.dart  # ML inference
└── screens/
    ├── home_screen.dart               # Main navigation hub
    ├── learning_modules_screen.dart    # Learning modules list
    ├── learning_module_screen.dart     # Module viewer
    ├── troubleshooting_screen.dart     # Troubleshooting guides
    └── species_identification_screen.dart  # Species identifier
    
assets/
├── models/
│   ├── model_unquant.tflite           # TensorFlow Lite model
│   └── labels.txt                     # Species labels
├── images/                            # (Ready for images)
└── videos/                            # (Ready for videos)
```

## Getting Started

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK (3.10.1 or higher)
- Android Studio or Xcode (for device testing)

### Installation

1. **Clone the project:**
   ```bash
   cd c:\Users\tamba\Projects\ostrea
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Key Services

### LocalStorageService
Manages local data persistence:
```dart
// Save module progress
await LocalStorageService.saveModuleProgress('module1', 2);

// Mark module as complete
await LocalStorageService.completeModule('module1');

// Bookmark content
await LocalStorageService.addBookmark('module1');
```

### SpeciesIdentificationService
ML-powered species classification:
```dart
final service = SpeciesIdentificationService();
await service.initialize();

final result = await service.identifySpecies(imageBytes);
// Returns: {species, confidence, allPredictions}
```

## Learning Modules Content

### Module 1: Introduction to Oyster Farming
- Basics of sustainable aquaculture
- Three farming systems (pond, bag, cage)
- Oyster lifecycle (breeding to harvest)
- Daily monitoring requirements

### Module 2: Water Quality Management
- Critical parameters: pH, DO, Salinity, Temperature
- Optimal ranges for each parameter
- Daily monitoring practices
- Species-specific requirements

### Module 3: Nutrition and Feeding
- Filter-feeding mechanisms
- Phytoplankton and zooplankton
- Water flow requirements
- Supplemental feeding strategies

### Module 4: Disease Prevention
- Disease categories (bacterial, parasitic, viral)
- Prevention through water quality
- Quarantine protocols
- Sanitation practices

### Module 5: Spat Collection
- Natural vs. hatchery spat
- Settlement substrate preparation
- Optimal collection conditions
- Predator protection

### Module 6: Growth & Harvesting
- Growth optimization strategies
- Stocking density management
- Market-size determination
- Harvest and post-harvest handling

## Troubleshooting Guides

Each guide includes:
- **Problem Description:** What to look for
- **Root Cause:** Why it's happening
- **Solutions:** 3-5 actionable steps
- **Severity Level:** High/Medium/Low priority

## Species Identification Model

**Input Requirements:**
- Image size: 224x224 pixels
- Format: JPEG/PNG
- Quality: Clear, well-lit photos

**Output:**
- Species name with scientific classification
- Confidence percentage (0-100%)
- Top 3 alternative predictions
- Type: Shell or Meat

**Species Labels:**
0. Eastern Oyster (Crassostrea virginica)-Shell
1. Eastern Oyster (Crassostrea virginica)-Meat
2. Pacific Oyster (Crassostrea gigas)-Shell
3. Pacific Oyster (Crassostrea gigas)-Meat
4. Mangrove Oyster (Crassostrea iredalei)-Shell
5. Mangrove Oyster (Crassostrea iredalei)-Meat

## UI Design

### Color Scheme
- **Primary:** Green (#2E7D32) - Nature & sustainability
- **Secondary:** Dark Green (#1B5E20) - Professional
- **Accent:** Orange (#FF6F00) - Highlights & CTAs
- **Background:** Light Gray (#FAFAFA)
- **Surface:** White (#FFFFFF)

### Navigation
- **Bottom Navigation Bar** with 4 main sections:
  1. Home - Dashboard & key info
  2. Learn - Learning modules
  3. Troubleshoot - Problem guides
  4. Identify - Species identification

## Offline Functionality

- ✅ All learning content stored locally
- ✅ Troubleshooting guides available offline
- ✅ ML inference works without internet
- ✅ Progress tracking stored locally
- ✅ No authentication needed
- ✅ No external API calls

## Code Style & Best Practices

- **Simple & Readable:** Beginner-friendly code
- **Well-Commented:** Inline documentation
- **Modular Structure:** Separated concerns
- **Error Handling:** User-friendly error messages
- **Responsive Design:** Works on all screen sizes

## Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2      # Local storage
  image_picker: ^1.0.4             # Camera/Gallery
  image: ^4.1.1                    # Image processing
  tflite_flutter: ^0.10.4           # ML inference
  video_player: ^2.8.1              # Video support
  path_provider: ^2.1.1             # File handling
```

## Future Enhancements

- [ ] Voice narration for learning modules
- [ ] Video tutorials
- [ ] Water quality monitoring tools
- [ ] Weather integration
- [ ] Multi-language support
- [ ] Harvest calendar planner
- [ ] Feed cost calculator
- [ ] Production analytics

## License

This project is designed for educational and agricultural use.

## Support

For questions or issues, refer to the in-app guides or troubleshooting section.

---

**Made for oyster farmers, by farmers. Learning never stops.** 🦪
