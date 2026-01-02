import 'package:blood_application/donate_blood_screen.dart';
import 'package:blood_application/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final loginEmailC = TextEditingController();
  final loginPassC = TextEditingController();
  final signNameC = TextEditingController();
  final signEmailC = TextEditingController();
  final signPassC = TextEditingController();

  bool loginHide = true;
  bool signupHide = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    loginEmailC.dispose();
    loginPassC.dispose();
    signNameC.dispose();
    signEmailC.dispose();
    signPassC.dispose();
    super.dispose();
  }

  InputDecoration fieldStyle(String text, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: text,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade200, // light background for readability
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade700, Colors.red.shade900],
              ),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.water_drop, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  "Blood Donation App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TabBar(
                  controller: tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 4,
                  tabs: const [
                    Tab(text: "LOGIN"),
                    Tab(text: "SIGN UP"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // LOGIN
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: loginEmailC,
                        decoration: fieldStyle("Email", Icons.email),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: loginPassC,
                        obscureText: loginHide,
                        decoration: fieldStyle(
                          "Password",
                          Icons.lock,
                          suffix: IconButton(
                            icon: Icon(loginHide
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                loginHide = !loginHide;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            final res = await context
                                .read<AuthProvider>()
                                .login(loginEmailC.text.trim(),
                                    loginPassC.text.trim());
                            setState(() => loading = false);

                            if (res != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(res)));
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const HomeScreen()));
                            }
                          },
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("LOGIN",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                // SIGNUP
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: signNameC,
                        decoration: fieldStyle("Name", Icons.person),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: signEmailC,
                        decoration: fieldStyle("Email", Icons.email),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: signPassC,
                        obscureText: signupHide,
                        decoration: fieldStyle(
                          "Password",
                          Icons.lock,
                          suffix: IconButton(
                            icon: Icon(signupHide
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                signupHide = !signupHide;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            final res = await context
                                .read<AuthProvider>()
                                .signUp(signNameC.text.trim(),
                                    signEmailC.text.trim(),
                                    signPassC.text.trim());
                            setState(() => loading = false);

                            if (res != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(res)));
                            } else {
                              tabController.animateTo(0);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Account created! Login now")));
                            }
                          },
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("SIGN UP",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
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
    );
  }
}
