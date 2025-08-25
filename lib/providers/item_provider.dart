import 'package:flutter/material.dart';
import '../models/item_model.dart';

class ItemProvider with ChangeNotifier {
 final List<ItemModel> _items = [
   ItemModel(
    id: '5',
    name: 'Sandwich',
    description: 'Healthy vegetable sandwich packed with fresh cucumbers, tomatoes, lettuce, and cheese. Lightly toasted and served with a creamy spread. Ideal for a quick bite.',
    price: 149,
    discount: 5,
    imageUrl: 'https://www.cleankitchen.ee/cdn/shop/files/oyCtmVRSF59lqPmz-foynevLQ8nUy_AB-UfUUjB42co.jpg?crop=center&height=700&v=1727230358&width=1050',
    discountedPrice: 149 - (149 * 5 / 100),
  ),
  ItemModel(
    id: '3',
    name: 'Pasta',
    description: 'Creamy white sauce pasta made with penne and mixed vegetables. Topped with herbs and parmesan cheese. Smooth, rich, and perfect for dinner or lunch.',
    price: 249,
    discount: 15,
    imageUrl: 'https://www.indianhealthyrecipes.com/wp-content/uploads/2023/05/red-sauce-pasta-recipe.jpg',
    discountedPrice: 249 - (249 * 15 / 100),
  ),
    ItemModel(
    id: '2',
    name: 'Burger',
    description: 'Juicy chicken burger layered with fresh lettuce, tomatoes, cheese, and a soft bun. Made with premium chicken and special sauces. A filling and flavorful snack or meal.',
    price: 199,
    discount: 10,
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80',
    discountedPrice: 199 - (199 * 10 / 100),
  ),
  ItemModel(
    id: '4',
    name: 'French Fries',
    description: 'Golden crispy fries made from fresh potatoes. Lightly salted and perfectly fried for that crunchy bite. A classic side for every meal or snack.',
    price: 99,
    discount: 0,
    imageUrl: 'https://www.chefhasti.com/wp-content/uploads/2020/06/COVER-1-1-scaled.jpg',
    discountedPrice: 99,
  ),
   ItemModel(
    id: '1',
    name: 'Pizza',
    description: 'A delicious cheese-loaded pizza with a crispy base, tangy tomato sauce, and melting mozzarella. Perfect for every occasion. Ideal for sharing or indulging solo. Loved by kids and adults alike.',
    price: 299,
    discount: 20,
    imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=500',
    discountedPrice: 299 - (299 * 20 / 100),
  ),
  ItemModel(
    id: '7',
    name: 'Sushi',
    description: 'Fresh salmon sushi rolls with seasoned rice and nori. A delicate and premium Japanese delight. Served with wasabi and soy sauce. Perfect for sushi lovers.',
    price: 399,
    discount: 18,
    imageUrl: 'https://www.kikkoman.eu/fileadmin/_processed_/9/0/csm_1414_Vegan_Tempura_Sushi_Desktop_Header_148b8761b6.jpg',
    discountedPrice: 399 - (399 * 18 / 100),
  ),
  ItemModel(
    id: '8',
    name: 'Salad',
    description: 'A bowl of healthy green salad with lettuce, cucumbers, olives, cherry tomatoes, and vinaigrette. Fresh and fiber-rich. Great for diet-conscious customers.',
    price: 129,
    discount: 8,
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&q=80',
    discountedPrice: 129 - (129 * 8 / 100),
  ),
  ItemModel(
    id: '9',
    name: 'Ice Cream',
    description: 'Creamy vanilla ice cream scoop served cold and smooth. A timeless dessert that soothes your sweet cravings. Perfect after meals or as a snack.',
    price: 89,
    discount: 0,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9pjtJCRBBXnRudgc1aM6uPCqiq_Ot9LTA8g&s',
    discountedPrice: 89,
  ),
  ItemModel(
    id: '10',
    name: 'Noodles',
    description: 'Hot and spicy noodles with vegetables and Asian spices. A quick and satisfying comfort meal. Served steaming with bold flavors.',
    price: 159,
    discount: 7,
    imageUrl: 'https://www.ohmyveg.co.uk/wp-content/uploads/2024/08/hakka-noodles.jpg',
    discountedPrice: 159 - (159 * 7 / 100),
  ),
  ItemModel(
    id: '11',
    name: 'Paneer Tikka',
    description: 'Grilled paneer cubes marinated in Indian spices. Served hot with onions and chutney. A vegetarian delight packed with flavor and protein.',
    price: 219,
    discount: 14,
    imageUrl: 'https://sharethespice.com/wp-content/uploads/2024/02/Paneer-Tikka-Featured.jpg',
    discountedPrice: 219 - (219 * 14 / 100),
  ),
  ItemModel(
    id: '12',
    name: 'Dosa',
    description: 'Crispy masala dosa served with potato filling, coconut chutney, and sambhar. A South Indian favorite that’s light yet filling and tasty.',
    price: 139,
    discount: 9,
    imageUrl: 'https://www.awesomecuisine.com/wp-content/uploads/2009/06/Plain-Dosa.jpg',
    discountedPrice: 139 - (139 * 9 / 100),
  ),
];

  final List<String> _favorites = [];
  final Map<String, int> _cart = {};

  List<ItemModel> get items => _items;
  List<String> get favorites => _favorites;
  Map<String, int> get cart => _cart;

  void toggleFavorite(String itemId) {
    if (_favorites.contains(itemId)) {
      _favorites.remove(itemId);
    } else {
      _favorites.add(itemId);
    }
    notifyListeners();
  }

  void addToCart(String itemId) {
    _cart[itemId] = (_cart[itemId] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    if (_cart.containsKey(itemId)) {
      _cart[itemId] = _cart[itemId]! - 1;
      if (_cart[itemId]! <= 0) {
        _cart.remove(itemId);
      }
      notifyListeners();
    }
  }

  void removeItemCompletely(String itemId) {
    _cart.remove(itemId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}