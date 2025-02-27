import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../utils/ad/consent_manager.dart';

class BannerAdWidget extends StatefulWidget {
  final double padding;

  const BannerAdWidget({super.key, this.padding = 0});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  Orientation? _orientation;

  final _adUnitId = Platform.isAndroid
      ? const String.fromEnvironment('ANDROID_BANNER_AD_UNIT_ID')
      : const String.fromEnvironment('IOS_BANNER_AD_UNIT_ID');

  @override
  void initState() {
    super.initState();
    _initializeAds();
  }

  void _initializeAds() {
    ConsentManager.gatherConsent((consentError) {
      if (consentError != null) {
        debugPrint("Consent error: ${consentError.errorCode}: ${consentError.message}");
        _bannerAd?.dispose();
        _loadAd();
      }
    });
    _loadAd();
  }

  void _loadAd() async {
    if (!await ConsentManager.canRequestAds()) return;
    if (!mounted) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final adWidth = (screenWidth - widget.padding * 2).truncate();

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(adWidth);
    if (size == null) return;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          debugPrint("Banner ad loaded");
          _bannerAd = ad as BannerAd;
          _isLoaded = true;
        }),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_bannerAd == null || !_isLoaded) return const SizedBox.shrink();

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newOrientation = MediaQuery.of(context).orientation;
    if (_orientation != newOrientation) {
      if (_orientation != null) {
        _bannerAd?.dispose();
        _loadAd();
      }
      _orientation = newOrientation;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
