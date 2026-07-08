import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

import 'avatar_layout.dart';

/// Genera sprite sheets *placeholder* dibujados por código (sin PNG externos),
/// respetando el layout de [AvatarLayout] (4x4 de 32px).
///
/// Estilo "chibi": cabeza grande, ojos grandes, cuerpo pequeño. Cada pieza es
/// una capa independiente que se superpone (cuerpo, pelo, top, pantalón,
/// audífonos, arma) para componer el personaje.
typedef _FrameDraw = void Function(
    Canvas canvas, AvatarDirection dir, int frame, double bob);

class PlaceholderSheets {
  const PlaceholderSheets._();

  // Paleta placeholder
  static const _skin = Color(0xFFE8B27D);
  static const _skinShade = Color(0xFFCf9463);
  static const _white = Color(0xFFF8FAFC);
  static const _eye = Color(0xFF3B2A1A);
  static const _mouth = Color(0xFF8B4B4B);
  static const _freckle = Color(0xFFB5714A);

  // ---- capas ----
  static Future<ui.Image> body() => _sheet(_drawBody);
  static Future<ui.Image> hair({Color color = const Color(0xFF5B3A29)}) =>
      _sheet((c, d, f, b) => _drawHair(c, d, b, color));
  static Future<ui.Image> top({Color color = const Color(0xFF7C3AED)}) =>
      _sheet((c, d, f, b) => _drawTop(c, d, b, color));
  static Future<ui.Image> pants({Color color = const Color(0xFF475569)}) =>
      _sheet((c, d, f, b) => _drawPants(c, d, f, b, color));
  static Future<ui.Image> headphones(
          {Color color = const Color(0xFF9CA3AF)}) =>
      _sheet((c, d, f, b) => _drawHeadphones(c, d, b, color));
  static Future<ui.Image> weapon({Color color = const Color(0xFFCBD5E1)}) =>
      _sheet((c, d, f, b) => _drawWeapon(c, d, b, color));

  // ---------- infra ----------
  static const double _f = AvatarLayout.frameSize; // 32

  static Future<ui.Image> _sheet(_FrameDraw draw) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    for (var d = 0; d < AvatarLayout.rows; d++) {
      for (var f = 0; f < AvatarLayout.columns; f++) {
        canvas.save();
        canvas.translate(f * _f, d * _f);
        final bob = (f == 1 || f == 3) ? -1.0 : 0.0;
        draw(canvas, AvatarDirection.values[d], f, bob);
        canvas.restore();
      }
    }
    final side = (_f * AvatarLayout.columns).toInt(); // 128
    return recorder.endRecording().toImage(side, side);
  }

  static void _r(Canvas c, double x, double y, double w, double h, Color col) {
    c.drawRect(Rect.fromLTWH(x, y, w, h), Paint()..color = col);
  }

  static void _legs(Canvas c, int f, double bob, Color col) {
    final phase = f == 1
        ? 2.0
        : f == 3
            ? -2.0
            : 0.0;
    _r(c, 12, 24 + bob, 3, 6 + phase, col);
    _r(c, 17, 24 + bob, 3, 6 - phase, col);
  }

  // ---------- CUERPO (base + cara) ----------
  static void _drawBody(Canvas c, AvatarDirection dir, int f, double bob) {
    _legs(c, f, bob, _skin);
    _r(c, 11, 17 + bob, 10, 7, _skin); // torso
    _r(c, 8, 3 + bob, 16, 14, _skin); // cabeza grande (chibi)
    _drawFace(c, dir, bob);
  }

  static void _drawFace(Canvas c, AvatarDirection dir, double bob) {
    switch (dir) {
      case AvatarDirection.down:
        _r(c, 11, 9 + bob, 4, 4, _white);
        _r(c, 17, 9 + bob, 4, 4, _white);
        _r(c, 12, 10 + bob, 2, 3, _eye);
        _r(c, 18, 10 + bob, 2, 3, _eye);
        _r(c, 10, 14 + bob, 1, 1, _freckle);
        _r(c, 12, 14 + bob, 1, 1, _freckle);
        _r(c, 20, 14 + bob, 1, 1, _freckle);
        _r(c, 22, 14 + bob, 1, 1, _freckle);
        _r(c, 14, 15 + bob, 4, 1, _mouth);
        break;
      case AvatarDirection.left:
        _r(c, 9, 9 + bob, 4, 4, _white);
        _r(c, 9, 10 + bob, 2, 3, _eye);
        _r(c, 9, 15 + bob, 3, 1, _mouth);
        break;
      case AvatarDirection.right:
        _r(c, 19, 9 + bob, 4, 4, _white);
        _r(c, 21, 10 + bob, 2, 3, _eye);
        _r(c, 20, 15 + bob, 3, 1, _mouth);
        break;
      case AvatarDirection.up:
        break; // nuca (el pelo la cubre)
    }
  }

  // ---------- PELO ----------
  static void _drawHair(Canvas c, AvatarDirection dir, double bob, Color col) {
    if (dir == AvatarDirection.up) {
      _r(c, 7, 2 + bob, 18, 16, col); // nuca: melena completa
      return;
    }
    _r(c, 7, 2 + bob, 18, 6, col); // parte superior
    _r(c, 7, 2 + bob, 3, 15, col); // mechón izquierdo (largo)
    _r(c, 22, 2 + bob, 3, 15, col); // mechón derecho (largo)
    // flequillo
    if (dir == AvatarDirection.down) {
      _r(c, 10, 7 + bob, 3, 2, col);
      _r(c, 19, 7 + bob, 3, 2, col);
    }
  }

  // ---------- TOP / CAMISA ----------
  static void _drawTop(Canvas c, AvatarDirection dir, double bob, Color col) {
    _r(c, 10, 16 + bob, 12, 8, col);
    _r(c, 9, 17 + bob, 2, 4, col); // tirante izq
    _r(c, 21, 17 + bob, 2, 4, col); // tirante der
  }

  // ---------- PANTALÓN ----------
  static void _drawPants(
      Canvas c, AvatarDirection dir, int f, double bob, Color col) {
    _r(c, 11, 23 + bob, 10, 3, col);
    _legs(c, f, bob, col); // cubre las piernas
  }

  // ---------- AUDÍFONOS ----------
  static void _drawHeadphones(
      Canvas c, AvatarDirection dir, double bob, Color col) {
    if (dir == AvatarDirection.up) {
      _r(c, 7, 2 + bob, 18, 2, col); // diadema por detrás
      return;
    }
    _r(c, 8, 2 + bob, 16, 2, col); // diadema superior
    _r(c, 6, 9 + bob, 3, 5, col); // orejera izquierda
    _r(c, 23, 9 + bob, 3, 5, col); // orejera derecha
  }

  // ---------- ARMA ----------
  static void _drawWeapon(Canvas c, AvatarDirection dir, double bob, Color col) {
    switch (dir) {
      case AvatarDirection.down:
      case AvatarDirection.right:
        _r(c, 23, 8 + bob, 3, 16, col);
        _r(c, 22, 20 + bob, 5, 2, _skinShade); // empuñadura
        break;
      case AvatarDirection.up:
      case AvatarDirection.left:
        _r(c, 6, 8 + bob, 3, 16, col);
        _r(c, 5, 20 + bob, 5, 2, _skinShade);
        break;
    }
  }
}
