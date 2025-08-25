import 'package:carousel_slider/carousel_slider.dart';
import 'package:delivery_app/screens/see_all_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/location_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'icon': '🍽️'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Burger', 'icon': '🍔'},
    {'name': 'Pasta', 'icon': '🍝'},
    {'name': 'Fries', 'icon': '🍟'},
    {'name': 'Drinks', 'icon': '🥤'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Salad', 'icon': '🥗'},
    {'name': 'Dessert', 'icon': '🍨'},
  ];

  String _selectedCategory = 'All';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    if (locationProvider.currentLocation == '') {
      locationProvider.fetchCurrentLocation();
    }
  }

  //BottomNavBar onTap handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Already on Home
    } else if (index == 1) {
      Navigator.pushNamed(context, '/favorites');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/notifications');  
    } else if (index == 3) {
      Navigator.pushNamed(context, '/cart');
    } else if (index == 4) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    final products = itemProvider.items.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.name.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
       // 🔥 BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon( Icons.notifications), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.pushNamed(context, '/profile');
        //     },
        //     child: const CircleAvatar(
        //       backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
        //     ),
        //   ),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deliver to',
              style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 122, 122, 122)),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    locationProvider.currentLocation.isNotEmpty
                        ? locationProvider.currentLocation
                        : 'Set location',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 42, 42, 42),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/location');
                  },
                  child:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // // Favorite
          // ClipOval(
          //   child: Container(
          //     width: 46,
          //     height: 46,
          //     color: const Color.fromARGB(255, 193, 193, 193).withOpacity(0.2),
          //     child: IconButton(
          //       icon: const Icon(Icons.favorite_border, color: Colors.black),
          //       onPressed: () => Navigator.pushNamed(context, '/favorites'),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   width: 5,
          // ),
          // Cart
          ClipOval(
            child: Container(
              width: 46,
              height: 46,
              color: const Color.fromARGB(255, 193, 193, 193).withOpacity(0.2),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.black),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
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
            const SizedBox(height: 20),

            // Special Offer Banner
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Container(
            //     height: 140,
            //     width: double.maxFinite,
            //     decoration: BoxDecoration(
            //       color: Colors.green[400],
            //       borderRadius: BorderRadius.circular(20),
            //       image: DecorationImage(
            //         image: NetworkImage('https://images.unsplash.com/photo-1550547660-d9450f859349'),
            //         alignment: Alignment.centerRight,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //     padding: EdgeInsets.all(16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("30%", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            //         Text("Discount Only\nValid For Today!", style: TextStyle(color: Colors.white, fontSize: 16)),
            //       ],
            //     ),
            //   ),
            // ),
            // Sliding Banner
            CarouselSlider(
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 900),
                viewportFraction: 0.9,
              ),
              items: [
                'assets/images/Banner.png',
                'assets/images/Banner_offer.png',
              ].map((imagePath) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(imagePath, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // const Positioned(
                      //   bottom: 12,
                      //   left: 12,
                      //   child: Text(
                      //     'Delicious Recipes',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //       shadows: [
                      //         Shadow(
                      //           blurRadius: 5,
                      //           color: Colors.black54,
                      //           offset: Offset(2, 2),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Products Grid
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: GridView.builder(
            //     itemCount: products.length,
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 16,
            //       mainAxisSpacing: 16,
            //       childAspectRatio: 0.72,
            //     ),
            //     itemBuilder: (context, index) {
            //       final item = products[index];
            //       final isFavorite = itemProvider.favorites.contains(item.id);
            //       final inCart = itemProvider.cart[item.id] ?? 0;
            //       return GestureDetector(
            //         onTap: () => Navigator.pushNamed(context, '/item-details',
            //             arguments: item),
            //         child: Card(
            //           color: Colors.white,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16)),
            //           elevation: 4,
            //           child: Container(
            //             color: Colors.white,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Container(
            //                   color: Colors.white,
            //                   child: Stack(
            //                     children: [
            //                       ClipRRect(
            //                         borderRadius: BorderRadius.vertical(
            //                             top: Radius.circular(16)),
            //                         child: Image.network(
            //                           item.imageUrl,
            //                           height: 150,
            //                           width: double.maxFinite,
            //                           fit: BoxFit.cover,
            //                         ),
            //                       ),
            //                       if (item.discount > 0)
            //                         Positioned(
            //                           top: 8,
            //                           left: 8,
            //                           child: Container(
            //                             padding: EdgeInsets.symmetric(
            //                                 horizontal: 8, vertical: 4),
            //                             decoration: BoxDecoration(
            //                               color: Colors.green,
            //                               borderRadius:
            //                                   BorderRadius.circular(8),
            //                             ),
            //                             child: Text('${item.discount}% OFF',
            //                                 style: TextStyle(
            //                                     color: Colors.white,
            //                                     fontSize: 12)),
            //                           ),
            //                         ),
            //                       Positioned(
            //                         top: 8,
            //                         right: 8,
            //                         child: GestureDetector(
            //                           onTap: () =>
            //                               itemProvider.toggleFavorite(item.id),
            //                           child: CircleAvatar(
            //                             backgroundColor: Colors.white,
            //                             child: Icon(
            //                               isFavorite
            //                                   ? Icons.favorite
            //                                   : Icons.favorite_border,
            //                               color: Colors.red,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(10),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(item.name,
            //                           style: TextStyle(
            //                               fontWeight: FontWeight.bold,
            //                               fontSize: 16),
            //                           maxLines: 1,
            //                           overflow: TextOverflow.ellipsis),
            //                       SizedBox(height: 4),
            //                       Text('₹${item.price}',
            //                           style:
            //                               TextStyle(color: Colors.deepPurple)),
            //                       // Row(
            //                       //   mainAxisAlignment: MainAxisAlignment.center,
            //                       //   children: [
            //                       //     IconButton(
            //                       //       icon: Icon(Icons.remove_circle_outline),
            //                       //       onPressed: inCart > 0
            //                       //           ? () => itemProvider
            //                       //               .removeFromCart(item.id)
            //                       //           : null,
            //                       //     ),
            //                       //     Text('$inCart',
            //                       //         style: TextStyle(
            //                       //             fontWeight: FontWeight.bold,
            //                       //             fontSize: 16)),
            //                       //     IconButton(
            //                       //       icon: Icon(Icons.add_circle_outline),
            //                       //       onPressed: () =>
            //                       //           itemProvider.addToCart(item.id),
            //                       //     ),
            //                       //   ],
            //                       // ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

             Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Row(children: [
                        const Text('Special Offer',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                )),
                        const Spacer(),
                        GestureDetector(
                          // onTap: () async {
                          //   await recipeProvider.showRecipeNotification();
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const SeeAllItems()),
                          //   );
                          // },
                          onTap: () async {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SeeAllItems()),
                            );
                          },
                          child: const Text("See All",
                               style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),)),
                        
                        const Icon(Icons.keyboard_arrow_right,
                            color: Color(0xFF999999))
                      ]),
                    ),
                  ],
                ),
               
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 2),
            //   child: GridView.builder(
            //      //scrollDirection: Axis.horizontal,
            //       itemCount: products.length,
            //       shrinkWrap: true,
            //       physics: NeverScrollableScrollPhysics(),
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 16,
            //         mainAxisSpacing: 16,
            //         childAspectRatio: 0.72,
            //       ),
            //       itemBuilder: (context, index) {
            //         final item = products[index];
            //         final isFavorite = itemProvider.favorites.contains(item.id);
            //         return GestureDetector(
            //           onTap: () => Navigator.pushNamed(context, '/item-details',
            //               arguments: item),
            //           child: Card(
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20)),
            //             elevation: 4,
            //             child: Container(
            //               color: Colors.white,
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Container(
            //                       child: Stack(
            //                         children: [
            //                           // Image with rounded top corners
            //                           ClipRRect(
            //                             borderRadius: BorderRadius.vertical(
            //                                 top: Radius.circular(18),
            //                                 bottom: Radius.circular(18)),
            //                             child: Image.network(
            //                               item.imageUrl,
            //                               height: 136,
            //                               width: double.infinity,
            //                               fit: BoxFit.cover,
            //                             ),
            //                           ),
            //                           // Promo Tag
            //                           if (item.discount > 0)
            //                             Positioned(
            //                               top: 10,
            //                               left: 8,
            //                               child: Container(
            //                                 padding: EdgeInsets.symmetric(
            //                                     horizontal: 8, vertical: 4),
            //                                 decoration: BoxDecoration(
            //                                   color: Colors.green,
            //                                   borderRadius:
            //                                       BorderRadius.circular(6),
            //                                 ),
            //                                 child: Text(
            //                                   'PROMO',
            //                                   style: TextStyle(
            //                                       color: Colors.white,
            //                                       fontSize: 12,
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ),
            //                             ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   // Item Info
            //                   Padding(
            //                     padding: const EdgeInsets.all(4),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         // Title
            //                         Padding(
            //                           padding: const EdgeInsets.only(left: 6),
            //                           child: Text(
            //                             item.name,
            //                             style: TextStyle(
            //                                 fontSize: 16,
            //                                 fontWeight: FontWeight.bold),
            //                             maxLines: 1,
            //                             overflow: TextOverflow.ellipsis,
            //                           ),
            //                         ),
            //                         SizedBox(height: 2),
            //                         // Distance + Rating
            //                         Padding(
            //                           padding: const EdgeInsets.only(left: 2),
            //                           child: Row(
            //                             children: [
            //                               Icon(Icons.location_on_outlined,
            //                                   size: 14, color: Colors.grey),
            //                               //SizedBox(width: 2),
            //                               Text('1.5 km |',
            //                                   style: TextStyle(
            //                                       fontSize: 12,
            //                                       color: Colors.grey)),
            //                               // Text('${item.distance} km', style: TextStyle(fontSize: 12, color: Colors.grey)),
            //                               SizedBox(width: 2),
            //                               Icon(Icons.star,
            //                                   size: 14, color: Colors.orange),
            //                               SizedBox(width: 2),
            //                               Text('4.8',
            //                                   style: TextStyle(
            //                                       fontSize: 12,
            //                                       color: Colors.grey)),
            //                               //Text('${item.rating}', style: TextStyle(fontSize: 12, color: Colors.grey)),
            //                               SizedBox(width: 2),
            //                               Text('(1.2k)',
            //                                   style: TextStyle(
            //                                       fontSize: 12,
            //                                       color: Colors.grey)),
            //                               // Text('(${item.reviews})', style: TextStyle(fontSize: 12, color: Colors.grey)),
            //                             ],
            //                           ),
            //                         ),
            //                         SizedBox(height: 2),
            //                         // Price & old price
            //                         Padding(
            //                           padding: const EdgeInsets.only(
            //                               left: 6, right: 2),
            //                           child: Row(
            //                             children: [
            //                               Text(
            //                                 '₹${item.price.toStringAsFixed(2)} |',
            //                                 style: TextStyle(
            //                                     color: Colors.green,
            //                                     fontSize: 16,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                               SizedBox(width: 6),
            //                               Icon(Icons.delivery_dining,
            //                                   size: 16, color: Colors.green),
            //                               SizedBox(width: 18),
            //                               ClipOval(
            //                                 child: Container(
            //                                   color: Color.fromARGB(
            //                                           255, 228, 228, 228)
            //                                       .withOpacity(0.2),
            //                                   width: 32,
            //                                   height: 32,
            //                                   child: IconButton(
            //                                     icon: Icon(
            //                                       isFavorite
            //                                           ? Icons.favorite
            //                                           : Icons.favorite_border,
            //                                       color: Colors.red,
            //                                       size: 24,
            //                                     ),
            //                                     onPressed: () => itemProvider
            //                                         .toggleFavorite(item.id),
            //                                     padding: EdgeInsets.zero,
            //                                     constraints: BoxConstraints(),
            //                                   ),
            //                                 ),
            //                               ),
            //                               // Text(
            //                               //   '₹${item.price.toStringAsFixed(2)}',
            //                               //   style: TextStyle(
            //                               //     fontSize: 12,
            //                               //     decoration:
            //                               //         TextDecoration.lineThrough,
            //                               //     color: Colors.grey,
            //                               //   ),
            //                               // ),
            //                             ],
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            // ),

            SizedBox(
              height: 260, // adjust to fit your card height
              // width: double.maxFinite,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, index) {
                  final item = products[index];
                  final isFavorite = itemProvider.favorites.contains(item.id);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 200, // maintain a fixed card width like Grid
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, '/item-details',
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
                                          borderRadius:
                                              const BorderRadius.vertical(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                width: 28,
                                                height: 28,
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
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Category Chips
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final selected = _selectedCategory == cat['name'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = cat['name']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? Colors.lightGreen : Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Text(cat['icon']!,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 6),
                          Text(
                            cat['name']!,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            //  Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 2),
            //     child: GridView.builder(
            //        //scrollDirection: Axis.horizontal,
            //         itemCount: products.length,
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 1,
            //           crossAxisSpacing: 16,
            //           mainAxisSpacing: 16,
            //           childAspectRatio: 0.72,
            //         ),
            //         itemBuilder: (context, index) {
            //           final item = products[index];
            //           final isFavorite = itemProvider.favorites.contains(item.id);
            //           return GestureDetector(
            //             onTap: () => Navigator.pushNamed(context, '/item-details',
            //                 arguments: item),
            //             child: Card(
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(20)),
            //               elevation: 4,
            //               child: Container(
            //                 color: Colors.white,
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Container(
            //                         child: Stack(
            //                           children: [
            //                             // Image with rounded top corners
            //                             ClipRRect(
            //                               borderRadius: BorderRadius.vertical(
            //                                   top: Radius.circular(18),
            //                                   bottom: Radius.circular(18)),
            //                               child: Image.network(
            //                                 item.imageUrl,
            //                                 height: 136,
            //                                 width: double.infinity,
            //                                 fit: BoxFit.cover,
            //                               ),
            //                             ),
            //                             // Promo Tag
            //                             if (item.discount > 0)
            //                               Positioned(
            //                                 top: 10,
            //                                 left: 8,
            //                                 child: Container(
            //                                   padding: EdgeInsets.symmetric(
            //                                       horizontal: 8, vertical: 4),
            //                                   decoration: BoxDecoration(
            //                                     color: Colors.green,
            //                                     borderRadius:
            //                                         BorderRadius.circular(6),
            //                                   ),
            //                                   child: Text(
            //                                     'PROMO',
            //                                     style: TextStyle(
            //                                         color: Colors.white,
            //                                         fontSize: 12,
            //                                         fontWeight: FontWeight.bold),
            //                                   ),
            //                                 ),
            //                               ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                     // Item Info
            //                     Padding(
            //                       padding: const EdgeInsets.all(4),
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           // Title
            //                           Padding(
            //                             padding: const EdgeInsets.only(left: 6),
            //                             child: Text(
            //                               item.name,
            //                               style: TextStyle(
            //                                   fontSize: 16,
            //                                   fontWeight: FontWeight.bold),
            //                               maxLines: 1,
            //                               overflow: TextOverflow.ellipsis,
            //                             ),
            //                           ),
            //                           SizedBox(height: 2),
            //                           // Distance + Rating
            //                           Padding(
            //                             padding: const EdgeInsets.only(left: 2),
            //                             child: Row(
            //                               children: [
            //                                 Icon(Icons.location_on_outlined,
            //                                     size: 14, color: Colors.grey),
            //                                 //SizedBox(width: 2),
            //                                 Text('1.5 km |',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         color: Colors.grey)),
            //                                 // Text('${item.distance} km', style: TextStyle(fontSize: 12, color: Colors.grey)),
            //                                 SizedBox(width: 2),
            //                                 Icon(Icons.star,
            //                                     size: 14, color: Colors.orange),
            //                                 SizedBox(width: 2),
            //                                 Text('4.8',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         color: Colors.grey)),
            //                                 //Text('${item.rating}', style: TextStyle(fontSize: 12, color: Colors.grey)),
            //                                 SizedBox(width: 2),
            //                                 Text('(1.2k)',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         color: Colors.grey)),
            //                                 // Text('(${item.reviews})', style: TextStyle(fontSize: 12, color: Colors.grey)),
            //                               ],
            //                             ),
            //                           ),
            //                           SizedBox(height: 2),
            //                           // Price & old price
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                                 left: 6, right: 2),
            //                             child: Row(
            //                               children: [
            //                                 Text(
            //                                   '₹${item.price.toStringAsFixed(2)} |',
            //                                   style: TextStyle(
            //                                       color: Colors.green,
            //                                       fontSize: 16,
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                                 SizedBox(width: 6),
            //                                 Icon(Icons.delivery_dining,
            //                                     size: 16, color: Colors.green),
            //                                 SizedBox(width: 18),
            //                                 ClipOval(
            //                                   child: Container(
            //                                     color: Color.fromARGB(
            //                                             255, 228, 228, 228)
            //                                         .withOpacity(0.2),
            //                                     width: 32,
            //                                     height: 32,
            //                                     child: IconButton(
            //                                       icon: Icon(
            //                                         isFavorite
            //                                             ? Icons.favorite
            //                                             : Icons.favorite_border,
            //                                         color: Colors.red,
            //                                         size: 24,
            //                                       ),
            //                                       onPressed: () => itemProvider
            //                                           .toggleFavorite(item.id),
            //                                       padding: EdgeInsets.zero,
            //                                       constraints: BoxConstraints(),
            //                                     ),
            //                                   ),
            //                                 ),
            //                                 // Text(
            //                                 //   '₹${item.price.toStringAsFixed(2)}',
            //                                 //   style: TextStyle(
            //                                 //     fontSize: 12,
            //                                 //     decoration:
            //                                 //         TextDecoration.lineThrough,
            //                                 //     color: Colors.grey,
            //                                 //   ),
            //                                 // ),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         }),
            //   ),
            
            //list of produdct
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5, // Wider ratio for horizontal row
                ),
                itemBuilder: (context, index) {
                  final item = products[index];
                  final isFavorite = itemProvider.favorites.contains(item.id);

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/item-details',
                      arguments: item,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      //elevation: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imageUrl,
                                height: 140,
                                width: 128,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Row: Name + Promo
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // if (item.discount > 0)
                                      //   Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 6, vertical: 2),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.green,
                                      //       borderRadius: BorderRadius.circular(4),
                                      //     ),
                                      //     child: Text(
                                      //       'PROMO',
                                      //       style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // Favorite button
                                      ClipOval(
                                        child: Material(
                                          color: const Color.fromARGB(
                                                  255, 236, 236, 236)
                                              .withOpacity(0.2),
                                          child: InkWell(
                                            onTap: () => itemProvider
                                                .toggleFavorite(item.id),
                                            child: SizedBox(
                                              width: 36,
                                              height: 36,
                                              child: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Distance + Rating
                                  const Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          size: 14, color: Colors.grey),
                                      SizedBox(width: 2),
                                      Text(
                                        '1.5 km |',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.star,
                                          size: 14, color: Colors.orange),
                                      SizedBox(width: 2),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '(1.2k)',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Price + Favorite
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.delivery_dining,
                                              size: 20, color: Colors.green),
                                          const SizedBox(width: 6),
                                          Text(
                                            '₹${(item.discount > 0 ? item.discountedPrice : item.price).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 84, 84, 84)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '₹${item.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
