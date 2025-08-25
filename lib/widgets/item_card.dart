import 'package:flutter/material.dart';
import '../models/item_model.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onAddToCart;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const ItemCard({
    Key? key,
    required this.item,
    required this.onAddToCart,
    this.onFavorite,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  Row(
                    children: [
                      Text(' [1m₹${item.price.toStringAsFixed(2)} [0m', style: const TextStyle(fontSize: 16)),
                      if (item.discount > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('${item.discount}% OFF', style: const TextStyle(color: Colors.orange)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.orange),
              onPressed: onFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
              onPressed: onAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}