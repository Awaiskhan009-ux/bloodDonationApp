import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateBloodScreen extends StatefulWidget {
  const DonateBloodScreen({super.key});

  @override
  State<DonateBloodScreen> createState() => _DonateBloodScreenState();
}

class _DonateBloodScreenState extends State<DonateBloodScreen> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController cityC = TextEditingController();

  String bloodGroup = "A+";
  bool loading = false;

  Future<void> submitData() async {
    if (nameC.text.isEmpty || phoneC.text.isEmpty || cityC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      FocusScope.of(context).unfocus(); // keyboard hide
      setState(() => loading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw "User not logged in";
      }

      // ✅ FIX: add() instead of doc(uid)
      await FirebaseFirestore.instance.collection("donors").add({
        "name": nameC.text.trim(),
        "phone": phoneC.text.trim(),
        "city": cityC.text.trim(),
        "bloodGroup": bloodGroup,
        "available": true,
        "userId": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donor added successfully ❤️")),
      );

      nameC.clear();
      phoneC.clear();
      cityC.clear();

    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    phoneC.dispose();
    cityC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate Blood"),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneC,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone",
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: cityC,
              decoration: InputDecoration(
                labelText: "City",
                prefixIcon: const Icon(Icons.location_city),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: bloodGroup,
              decoration: InputDecoration(
                labelText: "Blood Group",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                "A+","A-","B+","B-","O+","O-","AB+","AB-"
              ].map((bg) {
                return DropdownMenuItem(
                  value: bg,
                  child: Text(bg),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => bloodGroup = value!);
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: loading ? null : submitData,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SUBMIT",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
