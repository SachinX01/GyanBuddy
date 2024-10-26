import 'package:flutter/material.dart';

class Module {
  final String name;
  final String description;
  final String thumbnailPath;
  final MaterialPageRoute route;
  final Color backgroundColor;
  final CompletionCriteria completionCriteria;

  Module({
    required this.name,
    required this.description,
    required this.thumbnailPath,
    required this.route,
    required this.backgroundColor,
    required this.completionCriteria,
  });
}

enum CompletionCriteria {
  quizPassed,
  allItemsViewed,
}

// class Module {
//   final String name;
//   final String description;
//   final String thumbnailPath;
//   final MaterialPageRoute route;
//   Color backgroundColor;

//   Module({
//     required this.name,
//     required this.description,
//     required this.thumbnailPath,
//     required this.route,
//     required this.backgroundColor,
//   });
// }
