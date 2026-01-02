import 'package:blood_application/widgets/donor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindDonorScreen extends StatelessWidget {
  const FindDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Donor"),
        backgroundColor: Colors.red.shade800,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("donors")
            .where("available", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final donors = snapshot.data!.docs;

          if (donors.isEmpty) {
            return const Center(child: Text("No donors found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final data =
                  donors[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DonorDetailScreen(
                        donorData: data,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade700,
                      child: Text(
                        data["bloodGroup"] ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      data["name"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(data["city"] ?? ""),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
