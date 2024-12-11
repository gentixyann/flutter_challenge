import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageControllerProvider = Provider<PageController>(
  (ref) => PageController(viewportFraction: 0.85),
);
