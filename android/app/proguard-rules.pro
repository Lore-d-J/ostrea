# TensorFlow Lite rules
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.gpu.**

# Flutter logic often uses reflection which can be stripped by R8
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }