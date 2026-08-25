class Coupon {
  final String code;
  final double percentage;
  final bool isActive;
  final DateTime? expiresAt;

  const Coupon({
    required this.code,
    required this.percentage,
    required this.isActive,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;

    return expiresAt!.isBefore(DateTime.now());
  }

  double calculateDiscount(double price) {
    return price * (percentage / 100);
  }

  double calculateFinalPrice(double price) {
    return price - calculateDiscount(price);
  }
}
