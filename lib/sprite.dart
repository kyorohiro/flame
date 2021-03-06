import 'dart:ui';
import 'dart:async';

import 'package:flame/position.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' show Colors;

class Sprite {
  Image image;
  Rect src;

  static final Paint paint = new Paint()..color = Colors.white;

  Sprite(String fileName, {double x = 0.0, double y = 0.0, double width = null, double height = null}) {
    Flame.images.load(fileName).then((img) {
      if (width == null) {
        width = img.width.toDouble();
      }
      if (height == null) {
        height = img.height.toDouble();
      }
      this.image = img;
      this.src = new Rect.fromLTWH(x, y, width, height);
    });
  }

  Sprite.fromImage(this.image, {double x = 0.0, double y = 0.0, double width = null, double height = null}) {
      if (width == null) {
        width = image.width.toDouble();
      }
      if (height == null) {
        height = image.height.toDouble();
      }
      this.src = new Rect.fromLTWH(x, y, width, height);
  }

  static Future<Sprite> loadSprite(String fileName, {double x = 0.0, double y = 0.0, double width = null, double height = null}) async {
    Image image = await Flame.images.load(fileName);
    return new Sprite.fromImage(image, x: x, y: y, width: width, height: height);
  }

  bool loaded() {
    return image != null && src != null;
  }

  double get _imageWidth => this.image.width.toDouble();
  double get _imageHeight => this.image.height.toDouble();

  Position get originalSize {
    if (!loaded()) {
      return null;
    }
    return new Position(_imageWidth, _imageHeight);
  }

  void renderPosition(Canvas canvas, Position p, [Position size]) {
    if (!this.loaded()) {
      return;
    }
    size ??= originalSize;
    renderRect(canvas, Position.rectFrom(p, size));
  }

  void render(Canvas canvas, [double width, double height]) {
    if (!this.loaded()) {
      return;
    }
    width ??= _imageWidth;
    height ??= _imageHeight;
    renderRect(canvas, new Rect.fromLTWH(0.0, 0.0, width, height));
  }

  void renderRect(Canvas canvas, Rect dst) {
    if (!this.loaded()) {
      return;
    }
    canvas.drawImageRect(image, src, dst, paint);
  }
}
