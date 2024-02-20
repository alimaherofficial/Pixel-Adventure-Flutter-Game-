// ignore_for_file: lines_longer_than_80_chars

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure_game/pixel_adventure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await initializeFunction();
  final game = PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}

/// This function run before the game starts.
/// It ensures that the game runs in full screen and landscape mode
Future<void> initializeFunction() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await Supabase.initialize(
    url: 'https://ljfvrfligsxhrzijnnic.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqZnZyZmxpZ3N4aHJ6aWpubmljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg0NDM3OTcsImV4cCI6MjAyNDAxOTc5N30.ZRxmelYDZRUH7DTIySqDnJD3b2hfZaV35N-9wqw3M1U',
  );
}
