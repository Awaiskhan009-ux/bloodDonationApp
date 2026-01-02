import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// PROFILE CARD
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.red.shade200,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            user?.email ?? "No Email",
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 30),

          /// SETTINGS OPTIONS
          settingTile(
            icon: Icons.person,
            title: "My Profile",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile screen coming soon")),
              );
            },
          ),

          settingTile(
            icon: Icons.bloodtype,
            title: "My Donations",
            onTap: () {},
          ),

          settingTile(
            icon: Icons.info,
            title: "About App",
            onTap: () {},
          ),

          const Spacer(),

          /// LOGOUT
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
