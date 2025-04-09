import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/PlacementPredictionScreen.dart';
import 'package:untitled/Screen/TestListScreen.dart';
import 'package:untitled/Screen/profile.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Text(
                      user?.displayName?.substring(0, 1).toUpperCase() ?? "A",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Glassmorphic Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for tests, skills...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Neumorphic-style Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildOption(context, 'Aptitude', Icons.calculate, Colors.orangeAccent, 'Aptitude'),
                    _buildOption(context, 'Programming', Icons.code, Colors.green, 'Programming'),
                    _buildOption(context, 'Full Test', Icons.assignment, Colors.purple, 'All'),
                    _buildOption(context, 'Soft Skills', Icons.people, Colors.blue, 'Soft Skills'),
                    _buildOption(context, 'Mock Interview', Icons.mic, Colors.pink, ''),
                    _buildOption(context, 'Resume', Icons.description, Colors.teal, ''),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
                ],
              ),
              child: BottomNavigationBar(
                selectedItemColor: Colors.deepPurple,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  switch (index) {
                    case 1:
                      Navigator.push(context, _fadeRoute(TestListScreen()));
                      break;
                    case 2:
                      Navigator.push(context, _fadeRoute(PlacementPredictionScreen()));
                      break;
                    case 3:
                      Navigator.push(context, _fadeRoute(ProfilePage()));
                      break;
                  }
                },
                currentIndex: 0,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Tests"),
                  BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Predict"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern neumorphic styled tiles with gradient icon
  Widget _buildOption(BuildContext context, String title, IconData icon, Color color, String category) {
    return GestureDetector(
      onTap: () {
        if (category.isNotEmpty) {
          Navigator.push(context, _fadeRoute(TestListScreen(category: category)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title clicked')));
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.transparent,
                child: Icon(icon, color: Colors.white, size: 26),
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Route _fadeRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}