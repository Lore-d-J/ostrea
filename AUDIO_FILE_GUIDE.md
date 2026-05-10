# Audio File Organization Guide

## Folder Structure

```
assets/audio/
├── modules/
│   ├── module_001/
│   ├── module_002/
│   ├── module_003/
│   ├── module_004/
│   ├── module_005/
│   ├── module_006/
│   ├── module_007/
│   ├── module_008/
│   ├── module_009/
│   ├── module_010/
│   ├── module_011/
│   ├── module_012/
│   ├── module_013/
│   ├── module_014/
│   ├── module_015/
│   └── module_016/
└── guides/
```

## File Naming Convention

### For Module Audio Files

Place MP3 files in the appropriate module folder using this naming:

- **Single section module**: `ttsModule1.mp3`
- **Multiple sections in Module 1**:
  - `ttsModule1Section1.mp3`
  - `ttsModule1Section2.mp3`
  - `ttsModule1Section3.mp3` (etc.)

- **Module 2**: `ttsModule2.mp3`, `ttsModule2Section1.mp3`, etc.
- **Module 3**: `ttsModule3.mp3`, `ttsModule3Section1.mp3`, etc.
- **... up to Module 16**: `ttsModule16.mp3`, `ttsModule16Section1.mp3`, etc.

### For Troubleshooting Guide Audio Files

Place MP3 files in `assets/audio/guides/` using this naming:

- `ttsTroubleshoot1.mp3`
- `ttsTroubleshoot2.mp3`
- `ttsTroubleshoot3.mp3`
- `... up to ttsTroubleshoot8.mp3`

## Example Setup

```
assets/audio/
├── modules/
│   ├── module_001/
│   │   ├── ttsModule1.mp3          (if single section)
│   │   ├── ttsModule1Section1.mp3  (if multiple sections)
│   │   └── ttsModule1Section2.mp3
│   ├── module_002/
│   │   ├── ttsModule2Section1.mp3
│   │   ├── ttsModule2Section2.mp3
│   │   └── ttsModule2Section3.mp3
│   ├── module_003/
│   │   └── ttsModule3.mp3
│   ├── module_004/
│   │   ├── ttsModule4.mp3
│   │   └── ttsModule4Section1.mp3
│   ├── module_005/
│   │   └── ttsModule5.mp3
│   ├── module_006/
│   │   ├── ttsModule6Section1.mp3
│   │   └── ttsModule6Section2.mp3
│   ├── module_007/
│   │   └── ttsModule7.mp3
│   ├── module_008/
│   │   ├── ttsModule8Section1.mp3
│   │   ├── ttsModule8Section2.mp3
│   │   └── ttsModule8Section3.mp3
│   ├── module_009/
│   │   └── ttsModule9.mp3
│   ├── module_010/
│   │   └── ttsModule10.mp3
│   ├── module_011/
│   │   └── ttsModule11.mp3
│   ├── module_012/
│   │   └── ttsModule12.mp3
│   ├── module_013/
│   │   └── ttsModule13.mp3
│   ├── module_014/
│   │   └── ttsModule14.mp3
│   ├── module_015/
│   │   └── ttsModule15.mp3
│   └── module_016/
│       └── ttsModule16.mp3
└── guides/
    ├── ttsTroubleshoot1.mp3
    ├── ttsTroubleshoot2.mp3
    ├── ttsTroubleshoot3.mp3
    ├── ttsTroubleshoot4.mp3
    ├── ttsTroubleshoot5.mp3
    ├── ttsTroubleshoot6.mp3
    ├── ttsTroubleshoot7.mp3
    └── ttsTroubleshoot8.mp3
```

## Upload Instructions

1. Prepare your MP3 files with the correct names
2. Place them in the appropriate folder:
   - Module 1 audio → `assets/audio/modules/module_001/`
   - Module 2 audio → `assets/audio/modules/module_002/`
   - Module 3 audio → `assets/audio/modules/module_003/`
   - Module 4 audio → `assets/audio/modules/module_004/`
   - ... up to Module 16 audio → `assets/audio/modules/module_016/`
   - Guide audio → `assets/audio/guides/`
3. Rebuild the app - files will be automatically included
4. When you tap the play button in the app, it will find and play your audio file

## Error Messages

If an audio file is missing, the app will show a message like:
```
Place MP3: assets/audio/modules/module_001/ttsModule1Section1.mp3
```

This tells you exactly where to place the file.
