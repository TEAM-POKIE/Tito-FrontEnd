import 'package:flutter/material.dart';

class FreeState {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  int likes;

  FreeState({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.likes = 0,
  });

  
}
