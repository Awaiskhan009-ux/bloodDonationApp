import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final patientC = TextEditingController();
  final cityC = TextEditingController();
  final hospitalC = TextEditingController();
  final contactC = TextEditingController();

  String bloodGroup = "A+";
  String urgency = "Normal";
  bool loading = false;

  Future<void> submitRequest() async {
    if (patientC.text.isEmpty ||
        cityC.text.isEmpty ||
        hospitalC.text.isEmpty ||
        contactC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not logged in";

      await FirebaseFirestore.instance
          .collection("blood_requests")
          .add({
        "patientName": patientC.text.trim(),
        "city": cityC.text.trim(),
        "hospital": hospitalC.text.trim(),
        "contact": contactC.text.trim(),
        "bloodGroup": bloodGroup,
        "urgency": urgency,
        "requestBy": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Blood request submitted 🩸")),
      );

      patientC.clear();
      cityC.clear();
      hospitalC.clear();
      contactC.clear();

    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Request"),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField(patientC, "Patient Name", Icons.person),
            buildField(cityC, "City", Icons.location_city),
            buildField(hospitalC, "Hospital Name", Icons.local_hospital),
            buildField(contactC, "Contact Number", Icons.phone,
                type: TextInputType.phone),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: bloodGroup,
              decoration: const InputDecoration(labelText: "Blood Group"),
              items: const [
                "A+","A-","B+","B-","O+","O-","AB+","AB-"
              ].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (v) => setState(() => bloodGroup = v!),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: urgency,
              decoration: const InputDecoration(labelText: "Urgency"),
              items: const ["Normal", "Emergency"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (v) => setState(() => urgency = v!),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: loading ? null : submitRequest,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SUBMIT REQUEST",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
