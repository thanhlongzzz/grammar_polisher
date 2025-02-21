import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/navigation/app_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../commons/rounded_button.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController? _pageController;
  bool _isReviewing = false;
  bool _isTrying = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                OnboardingPage(
                  header: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      Assets.pngLauncherPlaystore,
                      width: 200,
                    ),
                  ),
                  label: 'Welcome to Oxford Dictionary 2.0!',
                  content: 'The best dictionary app in the world!\nWe\'re glad to have you here.\nLet\'s get started!',
                ),
                OnboardingPage(
                  header: Image.asset(
                    Assets.pngImg,
                    width: 200,
                  ),
                  label: 'Say goodbye with Grammarly AI',
                  content: 'We are very sorry to announce that this feature has been discontinued.\nWe will be back after improving and refining this feature. See you again on the Nibble app.\nThank you for your patience.',
                ),
                OnboardingPage(
                  header: VocabularyItem(
                    word: Words.sampleWord,
                    onMastered: () {},
                    onStar: () {},
                    viewOnly: true,
                  ),
                  label: 'View definitions and start learning!',
                  content: 'You can tap on any word to view its definition and start learning it.',
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OnboardingPage(
                      header: !_isTrying
                          ? Image.asset(
                              Assets.pngSample,
                            )
                          : VocabularyItem(
                              word: Words.sampleWord,
                              onMastered: () {},
                              onStar: () {},
                              viewOnly: true,
                            ),
                      label: 'Selection for more options',
                      content: 'Long press on any word to view more options.\n Look Up, Search web and even Translate.',
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RoundedButton(
                        onPressed: !_isTrying
                            ? () {
                                setState(() {
                                  _isTrying = true;
                                });
                              }
                            : null,
                        child: Text(!_isTrying ? 'Try it!' : 'Long press to definition...'),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OnboardingPage(
                      header: VocabularyItem(
                        word: Words.sampleWord.copyWith(status: _isReviewing ? WordStatus.star : WordStatus.unknown),
                        onMastered: () {},
                        onStar: () {
                          setState(() {
                            _isReviewing = !_isReviewing;
                          });
                        },
                        viewOnly: true,
                      ),
                      label: 'Review and Flashcard',
                      content:
                          'Modify the definition for your own understanding.\nAdd words to your review list and start learning with flashcards.\nNow, try pressing the star button!',
                    ),
                    const SizedBox(height: 16.0),
                    Opacity(
                      opacity: _isReviewing ? 1 : 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RoundedButton(
                          onPressed: _isReviewing
                              ? () {
                                  context.go(RoutePaths.flashcards, extra: {
                                    'words': [Words.sampleWord, Words.helloWord]
                                  });
                                }
                              : null,
                          child: const Text('Start learning'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          SmoothPageIndicator(
            controller: _pageController!,
            effect: WormEffect(
              dotColor: colorScheme.secondary.withValues(alpha: 0.3),
              activeDotColor: colorScheme.primary,
              dotHeight: 10,
              dotWidth: 10,
            ),
            count: 5,
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundedButton(
                onPressed: _onNext,
                child: const Text('Next'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onNext() {
    if (_pageController?.page?.toInt() == 4) {
      context.push(RoutePaths.vocabulary);
      return;
    }
    _pageController?.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
