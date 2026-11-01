import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final displayName = TextEditingController();
  final username = TextEditingController();
  bool loading = false;

  Future<void> createAccount() async {
    if (displayName.text.trim().isEmpty || username.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى إدخال جميع الحقول")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ، يرجى إعادة المحاولة")),
        );
        return;
      }

      // الـ ID الثابت هو UID الخاص بالمستخدم
      final fixedID = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(fixedID).set({
        'id': fixedID,
        'displayName': displayName.text.trim(),
        'username': username.text.trim(),
        'photoURL': '',
        'createdAt': DateTime.now(),
        'lastUsernameChange': DateTime.now(),
      });

      Navigator.pushReplacementNamed(context, '/home');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في إنشاء الحساب")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "إنشاء حسابك",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: displayName,
                decoration: const InputDecoration(
                  hintText: "اسم العرض",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: username,
                decoration: const InputDecoration(
                  hintText: "اسم المستخدم (يوزر)",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        "إنشاء الحساب",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
