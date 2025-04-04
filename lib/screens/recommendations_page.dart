import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  // Fake data
  final List<Map<String, dynamic>> recommendations = const [
    {
      'name': 'Pepperoni Pizza',
      'likes': 1423,
      'note': 'Based on your image scan history',
    },
    {
      'name': 'Margherita Pizza',
      'likes': 987,
      'note': 'Because you selected tomato and mozzarella',
    },
    {
      'name': 'Chicken Tikka Masala',
      'likes': 1205,
      'note': 'Popular among similar users',
    },
    {
      'name': 'Caesar Salad',
      'likes': 884,
      'note': 'You viewed this recipe last week',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🍽️ Dish Recommendations')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: recommendations.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final dish = recommendations[index];
          return ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: Text(dish['name'], style: const TextStyle(fontSize: 18)),
            subtitle: Text(dish['note']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 4),
                Text('${dish['likes']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
