class CaptionData {
  final String? id;
  final String caption;
  final List<String> tags;
  final String platform;
  final String style;
  final CaptionMetadata metadata;
  final String analysis;
  final DateTime createdAt;
  final bool saved;

  const CaptionData({
    this.id,
    required this.caption,
    required this.tags,
    required this.platform,
    required this.style,
    required this.metadata,
    required this.analysis,
    required this.createdAt,
    this.saved = false,
  });

  factory CaptionData.fromJson(Map<String, dynamic> json) {
    return CaptionData(
      id: json['id']?.toString(),
      caption: json['caption'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      platform: json['platform'] ?? 'instagram',
      style: json['style'] ?? 'casual',
      metadata: CaptionMetadata.fromJson(json['metadata'] ?? {}),
      analysis: json['analysis'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      saved: json['saved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caption': caption,
      'tags': tags,
      'platform': platform,
      'style': style,
      'metadata': metadata.toJson(),
      'analysis': analysis,
      'createdAt': createdAt.toIso8601String(),
      'saved': saved,
    };
  }

  CaptionData copyWith({
    String? id,
    String? caption,
    List<String>? tags,
    String? platform,
    String? style,
    CaptionMetadata? metadata,
    String? analysis,
    DateTime? createdAt,
    bool? saved,
  }) {
    return CaptionData(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags,
      platform: platform ?? this.platform,
      style: style ?? this.style,
      metadata: metadata ?? this.metadata,
      analysis: analysis ?? this.analysis,
      createdAt: createdAt ?? this.createdAt,
      saved: saved ?? this.saved,
    );
  }
}

class CaptionMetadata {
  final double confidence;
  final int processingTime;
  final String model;
  final List<String> emojis;
  final int hashtagCount;
  final int characterCount;
  final int wordCount;

  const CaptionMetadata({
    required this.confidence,
    required this.processingTime,
    required this.model,
    required this.emojis,
    required this.hashtagCount,
    required this.characterCount,
    required this.wordCount,
  });

  factory CaptionMetadata.fromJson(Map<String, dynamic> json) {
    return CaptionMetadata(
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      processingTime: json['processingTime'] ?? 0,
      model: json['model'] ?? '',
      emojis: List<String>.from(json['emojis'] ?? []),
      hashtagCount: json['hashtagCount'] ?? 0,
      characterCount: json['characterCount'] ?? 0,
      wordCount: json['wordCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confidence': confidence,
      'processingTime': processingTime,
      'model': model,
      'emojis': emojis,
      'hashtagCount': hashtagCount,
      'characterCount': characterCount,
      'wordCount': wordCount,
    };
  }
}

class CaptionResponse {
  final bool success;
  final String? message;
  final List<CaptionData>? data;
  final List<String>? captions;
  final int count;
  final String? style;
  final String? platform;
  final DateTime? generatedAt;

  const CaptionResponse({
    required this.success,
    this.message,
    this.data,
    this.captions,
    required this.count,
    this.style,
    this.platform,
    this.generatedAt,
  });

  factory CaptionResponse.fromJson(Map<String, dynamic> json) {
    return CaptionResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? List<CaptionData>.from(
              json['data'].map((x) => CaptionData.fromJson(x)))
          : null,
      captions:
          json['captions'] != null ? List<String>.from(json['captions']) : null,
      count: json['count'] ?? 0,
      style: json['style'],
      platform: json['platform'],
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'])
          : null,
    );
  }
}
