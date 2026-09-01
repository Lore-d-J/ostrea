import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImagePreprocessor {
  final int targetWidth;
  final int targetHeight;

  const ImagePreprocessor({this.targetWidth = 224, this.targetHeight = 224});

  Float32List preprocess(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Could not decode image');
    }

    final resizedImage = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
    );

    final inputBuffer = Float32List(targetWidth * targetHeight * 3);
    int pixelIndex = 0;

    for (int y = 0; y < targetHeight; y++) {
      for (int x = 0; x < targetWidth; x++) {
        final pixel = resizedImage.getPixel(x, y);
        inputBuffer[pixelIndex++] = pixel.r / 255.0;
        inputBuffer[pixelIndex++] = pixel.g / 255.0;
        inputBuffer[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return inputBuffer;
  }
}
