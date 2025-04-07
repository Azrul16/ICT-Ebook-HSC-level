import 'package:ebook/chapter4/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.purple,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background with Violet Theme
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7E57C2), // Medium Violet
                  Color(0xFF512DA8), // Deep Violet
                  Color(0xFF311B92), // Indigo-like Deep Violet
                ],
              ),
            ),
          ),

          // Top-left abstract circle
          Positioned(
            top: -70,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Top-right abstract circle
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Center-left abstract circle (Made larger)
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 50,
            left: -90,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Center-right abstract circle (Made larger)
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 300,
            right: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Bottom-center abstract circle
          Positioned(
            bottom: -120,
            left: MediaQuery.of(context).size.width / 2 -
                130, // Center the circle
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 250),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Don't just learn, Learn smart.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // const SizedBox(height: 50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // HTML Learning Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen1(), // Navigate to HomeScreen1
                            ),
                          );
                          print("HTML Learning clicked");
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "HTML",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E57C2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // C Programming Learning Button
                      GestureDetector(
                        onTap: () {
                          print("C Programming Learning clicked");
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "C-programming",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E57C2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Logo Section
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/ict_logo.png'), // Violet Logo
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
