import 'package:delivery_app/providers/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllItems extends StatefulWidget {
  const SeeAllItems({super.key});
  @override
  _SeeAllItemsState createState() => _SeeAllItemsState();
}

class _SeeAllItemsState extends State<SeeAllItems> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final filteredItems = itemProvider.items.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.name.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delicious Food',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 68, 68, 68)),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: 'What are you craving?',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                itemCount: filteredItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  //crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isFavorite = itemProvider.favorites.contains(item.id);

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/item-details',
                        arguments: item),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Stack(
                                  children: [
                                    // Image with rounded top corners
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(18),
                                          bottom: Radius.circular(18)),
                                      child: Image.network(
                                        item.imageUrl,
                                        height: 136,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // Promo Tag
                                    if (item.discount > 0)
                                      Positioned(
                                        top: 10,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${item.discount}% OFF',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // Item Info
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 2),

                                  // Distance + Rating
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 14, color: Colors.grey),
                                        Text('1.5 km |',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        SizedBox(width: 2),
                                        Icon(Icons.star,
                                            size: 14, color: Colors.orange),
                                        SizedBox(width: 2),
                                        Text('4.8',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        SizedBox(width: 2),
                                        Text('(1.2k)',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),

                                  // Price & Favorite Icon
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Row(
                                      children: [
                                        Text(
                                          '₹${(item.discount > 0 ? item.discountedPrice : item.price).toStringAsFixed(2)} |',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(Icons.delivery_dining,
                                            size: 16, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text(
                                          '₹${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        ClipOval(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                    255, 215, 215, 215)
                                                .withOpacity(0.2),
                                            width: 24,
                                            height: 24,
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                              onPressed: () => itemProvider
                                                  .toggleFavorite(item.id),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
