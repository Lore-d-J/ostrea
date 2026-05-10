# espeak-ng Android Setup Guide

## What's Implemented

The app now uses **espeak-ng** for offline Filipino text-to-speech with the following setup:

1. **Native Library Loading**: Loads `libespeak-ng.so` from `jniLibs/`
2. **Asset Extraction**: Automatically extracts binaries from assets if needed
3. **Gradle Integration**: Build script checks for binaries and provides guidance

## Getting espeak-ng Binaries

### Option A: Automatic Setup (Recommended)

Run the PowerShell setup script from the project root:

```powershell
.\setup-espeak-ng.ps1
```

This will:
- Create necessary directories
- Attempt to download binaries
- Set up folder structure

### Option B: Manual Download

1. **Download for ARM 64-bit** (most modern devices)
   - Visit: [espeak-ng Releases](https://github.com/espeak-ng/espeak-ng/releases)
   - Download: `libespeak-ng-arm64-v8a.so` or build from source
   - Place in: `android/app/src/main/jniLibs/arm64-v8a/libespeak-ng.so`

2. **Download for ARM 32-bit** (older devices - optional)
   - Download: `libespeak-ng-armeabi-v7a.so`
   - Place in: `android/app/src/main/jniLibs/armeabi-v7a/libespeak-ng.so`

### Option C: Build from Source

If pre-compiled binaries aren't available:

```bash
git clone https://github.com/espeak-ng/espeak-ng.git
cd espeak-ng
# Set up Android NDK toolchain and cross-compile for ARM
```

## Project Structure

```
android/app/src/main/
├── jniLibs/
│   ├── arm64-v8a/
│   │   └── libespeak-ng.so         # Place binary here
│   └── armeabi-v7a/
│       └── libespeak-ng.so         # Optional: 32-bit support
├── assets/
│   └── espeak-ng/
│       └── data/                    # Language data (optional)
└── kotlin/
    └── MainActivity.kt              # Handles TTS communication
```

## Building the App

Once binaries are placed:

```bash
flutter pub get
flutter build apk --debug
```

The gradle script will:
1. Check for binaries in `jniLibs/`
2. Alert you if they're missing
3. Build the APK with espeak-ng support

## Testing

1. **Install APK on device**:
   ```bash
   flutter install
   ```

2. **Test Filipino speech**:
   - The app will automatically use espeak-ng
   - Speech rate: 0.43 (slower for clarity)
   - Pitch: 1.05 (female-like tone)
   - Language: Filipino (tl)

## Troubleshooting

### "Failed to load libespeak-ng"
- Ensure binaries are in `android/app/src/main/jniLibs/`
- Match the ABI of your device (arm64-v8a for 64-bit)

### Speech not working
- Check device logs: `flutter logs`
- Verify binary placement
- Ensure execute permissions: `chmod +x libespeak-ng.so`

### Build fails
- Run: `flutter clean && flutter pub get`
- Verify gradle setup: `gradlew build --info`

## Automatic Download in CI/CD

To automate binary download in CI/CD:

```gradle
task downloadEspeakNg {
    doLast {
        // Downloads configured in espeakng.gradle
    }
}
```

The `espeakng.gradle` script is applied to `build.gradle.kts` and runs during build.

## Language Support

Default language: **Filipino** (tl/fil)

To use other languages, modify in `EspeakNgTts.kt`:
```kotlin
val lang_code = when (currentLanguage) {
    "tl" -> "fil"   // Filipino
    "en" -> "en"    // English
    "es" -> "es"    // Spanish
    else -> "fil"
}
```

## Next Steps

1. Run: `.\setup-espeak-ng.ps1`
2. Place binaries if needed
3. Build: `flutter build apk --debug`
4. Test on device
