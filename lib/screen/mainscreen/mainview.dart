import 'package:cook_book/const/colors.dart';
//import 'package:cook_book/screen/common/navbar.dart';
import 'package:cook_book/screen/mainscreen/Pages/createpage.dart';
import 'package:cook_book/screen/mainscreen/Pages/favouritepage.dart';
import 'package:cook_book/screen/mainscreen/Pages/homepage.dart';
import 'package:cook_book/screen/mainscreen/Pages/searchpage.dart';
import 'package:cook_book/screen/mainscreen/Pages/userpage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  int _selectedIndex = 0; // To track the selected index in GNav
  final PageController _pageController = PageController(); // To control the pages
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          Homepage(),
          Searchpage(),
          Favouritepage(),
          Createpage(),
          Userpage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(primary)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              _pageController.jumpToPage(index); // Navigate to selected page
            },
            color: const Color(primary),
            activeColor: const Color(primary),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 15), // Adjust padding here
            gap: 8, // Gap between icon and text
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.star_outline,
                text: 'Saved',
                textSize: 1,
              ),
              GButton(
                icon: Icons.list_alt_outlined,
                text: 'Create',
              ),
              GButton(
                icon: Icons.person_2_outlined,
                text: 'User',
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}
