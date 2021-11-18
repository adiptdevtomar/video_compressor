import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:video_compressor/video_compressor.dart';

/// The allowed video quality to pass for compression
enum VideoQuality {
  /// Very low quality
  very_low,

  /// Low quality
  low,

  /// Medium quality
  medium,

  /// High quality
  high,

  /// Very high quality
  very_high,
}

/// Light compressor that perform video compression and cancel compression
class VideoCompressor {
  /// Singleton instance of LightCompressor
  factory VideoCompressor() => _instance;

  VideoCompressor._internal();

  static final VideoCompressor _instance = VideoCompressor._internal();

  static const MethodChannel _channel = MethodChannel('video_compressor');

  /// A stream to listen to video compression progress
  static const EventChannel _progressStream =
  EventChannel('compression/stream');

  Stream<double>? _onProgressUpdated;

  /// Fires whenever the uploading progress changes.
  Stream<double> get onProgressUpdated {
    _onProgressUpdated ??= _progressStream
        .receiveBroadcastStream()
        .map<double>((dynamic result) => result != null ? result : 0);
    return _onProgressUpdated!;
  }

  Future<dynamic> compressVideo({
    required String path,
    required String destinationPath,
    required VideoQuality videoQuality,
    int? frameRate,
    bool isMinBitrateCheckEnabled = true,
    bool iosSaveInGallery = true,
  }) async {
    final Map<String, dynamic> response = jsonDecode(await _channel
        .invokeMethod<dynamic>('startCompression', <String, dynamic>{
      'path': path,
      'destinationPath': destinationPath,
      'videoQuality': videoQuality.toString().split('.').last,
      'frameRate': frameRate,
      'isMinBitrateCheckEnabled': isMinBitrateCheckEnabled,
      'saveInGallery': iosSaveInGallery,
    }));

    if (response['onSuccess'] != null) {
      return OnSuccess(response['onSuccess']);
    } else if (response['onFailure'] != null) {
      return OnFailure(response['onFailure']);
    } else if (response['onCancelled'] != null) {
      return OnCancelled(response['onCancelled']);
    } else {
      return const OnFailure('Something went wrong');
    }
  }

  /// Call this function to cancel video compression process.
  static Future<Map<String, dynamic>?> cancelCompression() async =>
      jsonDecode(await _channel.invokeMethod<dynamic>('cancelCompression'));
}
