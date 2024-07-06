class CalculateSize {
  static double getResponsiveSize(double figmaSize, double screenWidth) {
    double figmaScreenWidth = 391;
    return figmaSize * (screenWidth / figmaScreenWidth);
  }
}