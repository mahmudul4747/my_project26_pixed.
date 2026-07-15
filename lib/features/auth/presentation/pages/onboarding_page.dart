import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  Timer? _timer;

  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/assets/images/slider1.jpeg",
      
    },
    {
      "image": "assets/assets/images/slider2.jpeg",
     
    },
    {
      "image": "assets/assets/images/slider3.jpeg",
      
    },
    {
      "image": "assets/assets/images/slider4.jpeg",
     
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (!_pageController.hasClients) return;

        if (_currentPage < slides.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  void _next() {
    if (_currentPage == slides.length - 1) {
      _timer?.cancel();
      context.go('/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _timer?.cancel();
    context.go('/login');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// Slider
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {

              final slide = slides[index];

              return Stack(
                fit: StackFit.expand,
                children: [

                  /// Image
                  Image.asset(
                    slide["image"]!,
                    fit: BoxFit.cover,
                  ),

                  /// Dark Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [

                          Colors.black.withOpacity(.15),

                          Colors.transparent,

                          Colors.black.withOpacity(.72),

                        ],
                      ),
                    ),
                  ),

                  /// Title + Subtitle
                  if (slide["title"] != null && slide["subtitle"] != null)
  Positioned(
    left: 28,
    right: 28,
    bottom: 180,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: Column(
        key: ValueKey(index),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slide["title"]!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            slide["subtitle"]!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    ),
  ),
                ],
              );
            },
          ),
                    /// Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: SafeArea(
              child: TextButton(
                onPressed: _skip,
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          /// Bottom Area
          Positioned(
            left: 20,
            right: 20,
            bottom: 35,
            child: SafeArea(
              child: Row(
                children: [
                  /// Animated Dots
                  Expanded(
                    child: Row(
                      children: List.generate(
                        slides.length,
                        (index) {
                          final selected = _currentPage == index;

                          return AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 350),
                            margin:
                                const EdgeInsets.only(right: 8),
                            width: selected ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.orange
                                  : Colors.white54,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  /// Glass Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 12,
                        sigmaY: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          borderRadius:
                              BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),
                        child: SizedBox(
                          width: 180,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _next,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.orange,
                              foregroundColor:
                                  Colors.white,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage ==
                                          slides.length - 1
                                      ? "Get Started"
                                      : "Next",
                                  style:
                                      const TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}