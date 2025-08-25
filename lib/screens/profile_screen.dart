import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      Provider.of<AuthProvider>(context, listen: false)
          .updateUser(imagePath: picked.path);
    }
  }

  void _showEditSheet(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    final nameController = TextEditingController(text: user?.name ?? "");
    final emailController = TextEditingController(text: user?.email ?? "");
    final phoneController = TextEditingController(text: user?.phone ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Change User Information",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Phone Number",
                  ),
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Full Name",
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        onPressed: () {
                          authProvider.updateUser(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text("Save", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Center(child: const Text("Logout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)),
        content: const Text("Are you sure you want to log out?", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500),),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16),)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              
            ),
            // onPressed: () {
            //   authProvider.logout();
            //   Navigator.pop(context);
            // },
             onPressed: () async {
                        await authProvider.logout();
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                        }
                      },
            child: const Text("Yes", style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final imagePath = user?.imagePath;
    final phone = user?.phone ?? "No phone number";

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- User Info Card ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: (imagePath != null &&
                                    File(imagePath).existsSync())
                                ? FileImage(File(imagePath))
                                : const NetworkImage(
                                        "https://ui-avatars.com/api/?name=User")
                                    as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickImage(context),
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.deepOrange,
                                child: Icon(Icons.camera_alt,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                            const SizedBox(height: 4),
                            Text(user.phone ?? "No phone number"),
                            const SizedBox(height: 2),
                            Text(user.email),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showEditSheet(context, authProvider),
                        child: const CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 231, 217),
                      foregroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    
                    onPressed: () => _showLogoutDialog(context, authProvider),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Settings Section ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  // _buildTile(Icons.history_outlined, "Order History"),
                  _buildTiles(
                    Icons.history_outlined,
                    "Order History",
                    () {
                      Navigator.pushNamed(context, '/orderHistory');
                    },
                  ),

                  _buildTile(Icons.location_on, "My Locations"),
                  _buildTile(Icons.local_offer, "My Promotions"),
                  _buildTile(Icons.credit_card, "Payment Methods"),
                  _buildTile(Icons.message, "Messages"),
                  _buildTile(Icons.group, "Invite Friends"),
                  _buildTile(Icons.lock, "Security"),
                  _buildTile(Icons.help_outline, "Help Center"),
                  const Divider(),
                  _buildLanguageTile(),
                  _buildSwitchTile("Push Notification"),
                  _buildSwitchTile("Dark Mode"),
                  _buildSwitchTile("Sound"),
                  _buildSwitchTile("Automatically Updated"),
                  const Divider(),
                  _buildTile(Icons.description, "Terms of Service"),
                  _buildTile(Icons.privacy_tip, "Privacy Policy"),
                  _buildTile(Icons.info, "About App"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// --- Helper Widgets ---
  Widget _buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _buildTiles(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title) {
    return SwitchListTile(
      value: false,
      onChanged: (val) {},
      title: Text(title),
    );
  }

  Widget _buildLanguageTile() {
    String selected = "English";
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.deepOrange),
      title: const Text("Language"),
      trailing: DropdownButton<String>(
        value: selected,
        items: const [
          DropdownMenuItem(value: "English", child: Text("English")),
          DropdownMenuItem(value: "Hindi", child: Text("Hindi")),
        ],
        onChanged: (val) {
          // TODO: implement language change
        },
      ),
    );
  }
}
