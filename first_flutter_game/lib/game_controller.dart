import 'dart:math';
import 'package:first_flutter_game/components/enemy.dart';
import 'package:first_flutter_game/components/healthBar.dart';
import 'package:first_flutter_game/components/highScoreText.dart';
import 'package:first_flutter_game/components/startText.dart';
import 'package:first_flutter_game/enemySpawner.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'components/player.dart';
import 'components/score.dart';
import 'state.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  List <Enemy> enemies;
  HealthBar healthBar;
  EnemySpawner enemySpawner;
  int score;
  Score scoreText;
  Statee state;
  HighScoreText highScoreText;
  StartText startText;

  GameController(this.storage) {
    initialize();
  }
  void initialize() async{
    resize(await Flame.util.initialDimensions());
    state = Statee.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = Score(this);
    highScoreText = HighScoreText(this);
    startText = StartText(this);
  }

  void render(Canvas c) {
    //order is important
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint); // render background first
    player.render(c); //then render player so it would be on top of the background

    if (state == Statee.menu) {
       highScoreText.render(c);
       startText.render(c);
    } else {
    scoreText.render(c);
    enemies.forEach( (Enemy enemy) => enemy.render(c));
    healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == Statee.menu){
      highScoreText.update(t);
      startText.update(t);
    } else {
    enemies.forEach( (Enemy enemy) => enemy.update(t));
    enemies.removeWhere((Enemy enemy) => enemy.isDead);
    player.update(t);
    scoreText.update(t);
    healthBar.update(t);
    enemySpawner.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width/10;
  }

  void onTapDown(TapDownDetails d) {
    //print(d.globalPosition);
    if (state == Statee.menu){
      state = Statee.playing;
    } else {
    enemies.forEach((Enemy enemy) {
      if (enemy.enemyRect.contains(d.globalPosition)) {
        enemy.onTapDown();
      }
    });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch(rand.nextInt(4)){
      case 0:
        //Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        //Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        //bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        //Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}




