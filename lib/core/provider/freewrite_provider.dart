import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final freewriteProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
