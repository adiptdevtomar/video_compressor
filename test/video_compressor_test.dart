import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_compressor/src/video_compressor.dart';

void main() {
  const MethodChannel channel = MethodChannel('video_compressor');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
