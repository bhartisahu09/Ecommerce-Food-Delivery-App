import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final favoriteItems = itemProvider.items
        .where((item) => itemProvider.favorites.contains(item.id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.white,
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('No favorite items yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return Container(
                  color: Colors.white,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl.isNotEmpty
                                ? item.imageUrl
                                : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('₹${item.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => itemProvider.toggleFavorite(item.id),
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, '/item-details',
                            arguments: item),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
