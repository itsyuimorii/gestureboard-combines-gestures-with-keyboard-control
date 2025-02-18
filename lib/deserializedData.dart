import 'dart:convert';

/// Represents a 2D keypoint
class Keypoint {
  final double x;
  final double y;
  final String name;

  Keypoint({required this.x, required this.y, required this.name});

  factory Keypoint.fromJson(Map<String, dynamic> json){
    return Keypoint(
      x:json['x'],
      y:json['y'],
      name: json['name'],
    );
  }
  /// ??
  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'name': name};
}



/// Represents a 3D keypoint
class Keypoint3D {
  final double x;
  final double y;
  final double z;
  final String name;

  Keypoint3D({required this.x, required this.y, required this.z, required this.name});

  factory Keypoint3D.fromJson(Map<String, dynamic> json) {
    return Keypoint3D(
      x: json['x'],
      y: json['y'],
      z: json['z'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z, 'name': name};
}

/// Represents a detected gesture
class Gesture {
  final String name;
  final double score;

  Gesture({required this.name, required this.score});

 factory Gesture.fromJson(Map<String, dynamic> json) {
    return Gesture(
      name: json['name'],
      score: json['score'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
      };
}

 /// Represents a detected hand with 2D and 3D keypoints
class Hand {
  final List<Keypoint> keypoints;
  final List<Keypoint3D> keypoints3D;
  final String handedness;
  final double score;

  Hand({
    required this.keypoints,
    required this.keypoints3D,
    required this.handedness,
    required this.score,
  });

  factory Hand.fromJson(Map<String, dynamic> json) {
    return Hand(
      keypoints:
          (json['keypoints'] as List)
              .map<Keypoint>((kp) => Keypoint.fromJson(kp))
              .toList(),
      keypoints3D:
          (json['keypoints3D'] as List)
              .map<Keypoint3D>((kp) => Keypoint3D.fromJson(kp))
              .toList(),
      handedness: json['handedness'],
      score: json['score'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'keypoints': keypoints.map((kp) => kp.toJson()).toList(),
    'keypoints3D': keypoints3D.map((kp) => kp.toJson()).toList(),
    'handedness': handedness,
    'score': score,
  };
}

/// Represents a full detection result (Hand + Gestures)
class HandDetection {
  final Hand hand;
  final List<Gesture> gestures;

  HandDetection({required this.hand, required this.gestures});

  factory HandDetection.fromJson(Map<String, dynamic> json) {
    return HandDetection(
      hand: Hand.fromJson(json['hand']),
      gestures:
          (json['gestures'] as List).map<Gesture>((g) => Gesture.fromJson(g)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'hand': hand.toJson(),
    'gestures': gestures.map((g) => g.toJson()).toList(),
  };
}
