import 'package:blood_application/blood_request_screen.dart';
import 'package:blood_application/donate_blood_screen.dart';
import 'package:blood_application/widgets/find_donor_screen.dart';
import 'package:blood_application/widgets/setting_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // LOGO
              Container(
                height: 180,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              // GRID BOXES
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  // 1. Find Donor
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FindDonorScreen()),
                      );
                    },
                    child: _buildHomeBox(Icons.search, "Find Donor"),
                  ),
                  // 2. Donate Blood
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DonateBloodScreen()),
                      );
                    },
                    child: _buildHomeBox(Icons.water_drop, "Donate Blood"),
                  ),
                  // 3. Settings
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()  ));
                    },
                    child: _buildHomeBox(Icons.settings, "Settings"),
                  ),
                  // 4. Blood Request
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BloodRequestScreen()));
                    },
                    child: _buildHomeBox(
                        Icons.notification_important, "Blood Request"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeBox(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black26,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.red.shade800, size: 45),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
