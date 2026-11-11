class CostService {
  static const double baseFare = 5000;
  static const double pricePerKm = 2500;

  static double estimatedCost(double distanceKm) {
    return baseFare + (distanceKm * pricePerKm);
  }

  static String formatRupiah(double amount) {
    final value = amount.round().toString();

    final formatted = value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );

    return 'Rp $formatted';
  }
}
