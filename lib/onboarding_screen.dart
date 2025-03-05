import 'package:filmtok/homepage.dart';
import 'package:filmtok/signin.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  final List<Map<String, String>> _pages = [
    {"image": "🎬", "text": "Film için heyecanlı mısınız?"},
    {"image": "🍿", "text": "En sevdiğiniz filmleri keşfedin!"},
    {"image": "🎥", "text": "Hemen başlamak için hazır olun!"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Signin()),
                      ),
                  child: Text(
                    "Atla",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  return Center(
                    // **Önemli Nokta: İçeriği sabit tutmak için Center kullandık**
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _pages[index]['image']!,
                          style: TextStyle(fontSize: 80),
                        ),
                        SizedBox(height: 20),
                        Text(
                          _pages[index]['text']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: WormEffect(
                dotColor: Colors.white54,
                activeDotColor: Colors.white,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
            SizedBox(height: 20),
            // **Butonu sabitlemek için Align ve Padding ekledik**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _currentIndex == _pages.length - 1 ? 1.0 : 0.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed:
                        _currentIndex == _pages.length - 1
                            ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Signin()),
                            )
                            : null,
                    child: Text("Başla"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ), // **Butonu sayfanın altında sabit tutmak için boşluk ekledik**
          ],
        ),
      ),
    );
  }
}
