// ignore_for_file: public_member_api_docs

class Assets {
  Assets._();

  static const String level01 = 'level-01.tmx';

  static const String joystick = 'HUD/joystick.png';

  static const String joystickKnob = 'HUD/Knob.png';

  static String playerDoubleJump(String character) =>
      'Main Characters/$character/Double Jump (32x32).png';

  static String playerFall(String character) =>
      'Main Characters/$character/Fall (32x32).png';

  static String playerHit(String character) =>
      'Main Characters/$character/Hit (32x32).png';

  static String playerIdle(String character) =>
      'Main Characters/$character/Idle (32x32).png';

  static String playerJump(String character) =>
      'Main Characters/$character/Jump (32x32).png';

  static String playerRun(String character) =>
      'Main Characters/$character/Run (32x32).png';

  static String playerWallJump(String character) =>
      'Main Characters/$character/Wall Jump (32x32).png';
}
