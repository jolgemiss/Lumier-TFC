import 'package:flutter/material.dart';

Color ratingColor(double rating) {
  if (rating >= 7.0) return Colors.greenAccent[700]!;
  if (rating >= 5.0) return Colors.amber;
  return Colors.redAccent;
}
