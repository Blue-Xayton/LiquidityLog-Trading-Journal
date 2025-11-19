import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trading_journal/main.dart'; // path as needed
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  ProfilePage({super.key});

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/images/journal.jpg', fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.45))),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 16),
                CircleAvatar(radius: 48, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 48, color: Colors.white)),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), 
                    child: Container(
                      padding: EdgeInsets.all(18),
                      color: Colors.white.withOpacity(0.06),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text('Create your profile', style: GoogleFonts.inter(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _usernameController,
                              validator: (v) => (v==null || v.isEmpty) ? 'Enter a username' : null,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(labelText: 'Username', labelStyle: TextStyle(color: Colors.white70)),
                            ),
                            SizedBox(height: 8),
                            TextFormField(style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white70))),
                            SizedBox(height: 8),
                            TextFormField(maxLines: 3, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: Colors.white70))),
                            SizedBox(height: 18),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  String username = _usernameController.text;
                                  Navigator.pushReplacement(context, createFadeRoute(TradingJournalHomePage(username: username)));

                                }
                              },
                              child: Text('Save Profile', style: TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
