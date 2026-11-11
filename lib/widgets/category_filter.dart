import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  static const categories = ['Semua', 'Rumah Sakit', 'Puskesmas', 'Klinik'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final category in categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (_) => onChanged(category),
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryShortcuts extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const CategoryShortcuts({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _shortcut('Rumah Sakit', Icons.local_hospital, const Color(0xFFE94C69)),
        _shortcut(
          'Puskesmas',
          Icons.health_and_safety,
          const Color(0xFF20A66A),
        ),
        _shortcut('Klinik', Icons.medical_services, const Color(0xFF0875E1)),
        _shortcut('Semua', Icons.grid_view, Colors.orange),
      ],
    );
  }

  Widget _shortcut(String name, IconData icon, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => onSelected(name),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
