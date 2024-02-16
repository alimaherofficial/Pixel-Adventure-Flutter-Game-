import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure_game/pixel_adventure.dart';

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
}
