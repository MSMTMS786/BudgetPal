// Updated cards_screen.dart with realistic card UI, animation, better fonts
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentCardIndex = 0;

  final Color primaryBlue = const Color(0xFF0D47A1);

  final List<Map<String, dynamic>> _cards = [
    {
      'cardNumber': '4000 1234 5678 9010',
      'cardHolder': ' Misbah Ur Rehman',
      'expiryDate': '12/24',
      'cvv': '737',
      'cardType': 'Visa',
      'color': const Color(0xFF1565C0),
      'bankName': 'Visa Prepaid',
    },
    {
      'cardNumber': '5555 6666 7777 8888',
      'cardHolder': 'Misbah Rehman',
      'expiryDate': '08/25',
      'cvv': '357',
      'cardType': 'Mastercard',
      'color': const Color(0xFF212121),
      'bankName': 'Mastercard Debit',
    },
    {
      'cardNumber': '3782 822463 10005',
      'cardHolder': 'Misbah Ur Rehman',
      'expiryDate': '05/26',
      'cvv': '786',
      'cardType': 'AmericanExpress',
      'color': const Color(0xFF00695C),
      'bankName': 'American Express',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          'My Payment Cards',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _cards.length,
              onPageChanged: (index) {
                setState(() {
                  _currentCardIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final card = _cards[index];
                return AnimatedScale(
                  scale: _currentCardIndex == index ? 1 : 0.95,
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () => _showCardDetails(card),
                    child: _buildCreditCard(card),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card['color'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            card['bankName'],
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(),
                    child: Image(
                      image: AssetImage('assets/chip.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.wifi, color: Colors.white, size: 22),
                ],
              ),
              Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image(
                  image: AssetImage(
                    'assets/${card['cardType'].toLowerCase()}.png',
                  ),
                ),
              ),
            ],
          ),
          Text(
            card['cardNumber'],
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card['cardHolder'],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
              Text(
                card['expiryDate'],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              card['cardType'],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCardDetails(Map<String, dynamic> card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Card Holder: ${card['cardHolder']}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Card Number: ${card['cardNumber']}',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Expiry Date: ${card['expiryDate']}',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'CVV: ${card['cvv']}',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ],
            ),
          ),
    );
  }
}
