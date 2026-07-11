import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/user_profile_model.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(e.toString()),
          ),
        ),

        data: (UserProfileModel user) {
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [

              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.orange.shade100,
                  backgroundImage: user.photoUrl.isNotEmpty
                      ? NetworkImage(user.photoUrl)
                      : null,
                  child: user.photoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.deepOrange,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      _infoTile(
                        Icons.phone,
                        "Phone",
                        user.phone.isEmpty
                            ? "Not Added"
                            : user.phone,
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.location_on,
                        "Address",
                        user.address.isEmpty
                            ? "Not Added"
                            : user.address,
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.email,
                        "Email",
                        user.email,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: () {
                  context.push(
                    '/edit-profile',
                    extra: user,
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),

              const SizedBox(height: 14),

              FilledButton.icon(
                onPressed: () {
                  context.push('/my-orders');
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text("My Orders"),
              ),

              const SizedBox(height: 14),
                            FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  _logoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.orange.shade100,
        child: Icon(
          icon,
          color: Colors.deepOrange,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  void _logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);

                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}