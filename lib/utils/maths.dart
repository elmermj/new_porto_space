import 'dart:math';

class Maths {
  static double exponentialEaseInOut(double t) => t == 0.0 || t == 1.0
      ? t
      : t < 0.5
          ? 0.5 * pow(2, (20 * t) - 10)
          : 1 - 0.5 * pow(2, (-20 * t) + 10);
  static double cubicEaseInOut(double t) =>
      t < 0.5 ? 4 * t * t * t : 0.5 * pow(2 * t - 2, 3) + 1;
}