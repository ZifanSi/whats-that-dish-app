import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF955306),
        title: Text(
          'Home Page',
          style: GoogleFonts.lobster(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              text: 'What\'s That Dish?',
              routeName: '/blackboard',
            ),
            const SizedBox(height: 24),
            _buildButton(
              context,
              text: 'Recommendation Page',
              routeName: '/recommendation',
            ),
            const SizedBox(height: 24),
            _buildButton(
              context,
              text: 'Add Recipes',
              routeName: '/AddRecipePage',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String text, required String routeName}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF955306),
              offset: Offset(6, 6),
              blurRadius: 4,
            )
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
