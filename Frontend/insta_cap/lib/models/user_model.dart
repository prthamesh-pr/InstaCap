class User {
  final String id;
  final String email;
  final String? displayName;
  final String? profilePicture;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.profilePicture,
    this.isPremium = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      profilePicture: json['profilePicture'],
      isPremium: json['isPremium'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? profilePicture,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profilePicture: profilePicture ?? this.profilePicture,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

class UserStats {
  final int totalCaptions;
  final int savedCaptions;
  final int daysActive;
  final int monthlyUsage;
  final Map<String, int> platformUsage;
  final Map<String, int> styleUsage;

  const UserStats({
    required this.totalCaptions,
    required this.savedCaptions,
    required this.daysActive,
    required this.monthlyUsage,
    required this.platformUsage,
    required this.styleUsage,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalCaptions: json['totalCaptions'] ?? 0,
      savedCaptions: json['savedCaptions'] ?? 0,
      daysActive: json['daysActive'] ?? 0,
      monthlyUsage: json['monthlyUsage'] ?? 0,
      platformUsage: Map<String, int>.from(json['platformUsage'] ?? {}),
      styleUsage: Map<String, int>.from(json['styleUsage'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCaptions': totalCaptions,
      'savedCaptions': savedCaptions,
      'daysActive': daysActive,
      'monthlyUsage': monthlyUsage,
      'platformUsage': platformUsage,
      'styleUsage': styleUsage,
    };
  }
}
