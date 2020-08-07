import 'dart:ui';
import 'package:first_flutter_game/game_controller.dart';
class Player {

  final GameController gameController;
  int maxHealth;
  int currentHealth;
  Rect playerRect;
  bool isDead = false;

  Player(this.gameController) {
    maxHealth = 300;
    currentHealth = 300;
    final size = gameController.tileSize * 1.5;
      playerRect = Rect.fromLTWH(
      gameController.screenSize.width/2 - size/2, //to center the player
      gameController.screenSize.height/2 - size/2, //to center the player
      size,
      size);
  }

  void render(Canvas c) {
    Paint color = Paint()..color = Color(0xFF0000FF);
    c.drawRect(playerRect, color);
  }

  void update(double t) {
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }
}