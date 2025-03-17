import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/utils/extensions/list_extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/di.dart';
import '../../../generated/assets.dart';
import '../../../utils/global_values.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../paywall_button.dart';
import '../paywall_page.dart';

class PaywallDialog extends StatefulWidget {
  const PaywallDialog({super.key});

  @override
  State<PaywallDialog> createState() => _PaywallDialogState();
}

class _PaywallDialogState extends State<PaywallDialog> {
  static const primaryId = String.fromEnvironment("PRIMARY_PRODUCT_ID");
  static const secondaryId = String.fromEnvironment("SECONDARY_PRODUCT_ID");
  final _amplitude = DI().sl<Amplitude>();
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final spacing = 8.0;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return BlocBuilder<IapBloc, IapState>(
      builder: (context, state) {
        final primaryPrice = state.products.firstWhereOrNull((element) => element.id == primaryId)?.price ?? '\$4.99';
        final secondaryPrice = state.products.firstWhereOrNull((element) => element.id == secondaryId)?.price ?? '\$1.99';
        return Dialog(
          insetPadding: EdgeInsets.all(16.0),
          backgroundColor: colorScheme.surface,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Premium Features",
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Don't miss the chance to learn new words everyday!",
                          style: textTheme.titleMedium,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        Assets.pngLauncher,
                        height: size.height * 0.08,
                      ),
                    ],
                  ),
                  PaywallPage(),
                  SizedBox(height: 2 * spacing),
                  if (!GlobalValues.isShowFreeTrial) PaywallButton(
                    name: "Free 1 Day No Ads",
                    description: "Share to get 1 day free trial",
                    price: "Free",
                    onTap: () async {
                      _amplitude.track(BaseEvent('paywall_dialog_share'));
                      final result = await Share.share(
                        '''🚀 Master English with 6000 Oxford Words! 📚✨
            Boost your vocabulary with:
              ✅ 6000 Oxford Words – Learn essential English words
              ✅ Flashcards – Easy and effective memorization
              ✅ Notification Reminders – Never miss a learning session
            Start your journey to fluent English today! 🔥📖
            👉 ${const String.fromEnvironment("APP_URL")}''',
                      );
                      if (result.status == ShareResultStatus.success && context.mounted) {
                        GlobalValues.isShowFreeTrial = true;
                        context.read<IapBloc>().add(IapEvent.purchaseProduct(secondaryId, isFree: true));
                        context.pop();
                      }
                    },
                  ),
                  SizedBox(height: spacing),
                  PaywallButton(
                    name: "1 Day No Ads",
                    description: "+1 day use app without ads",
                    price: secondaryPrice,
                    onTap: () {
                      _amplitude.track(BaseEvent('paywall_dialog_purchase_product'));
                      context.read<IapBloc>().add(IapEvent.purchaseProduct(secondaryId));
                      context.pop();
                    },
                  ),
                  SizedBox(height: spacing),
                  PaywallButton(
                    name: "No Ads",
                    description: "Enjoy our app without any ads",
                    price: primaryPrice,
                    onTap: () {
                      _amplitude.track(BaseEvent('paywall_dialog_purchase_product'));
                      context.read<IapBloc>().add(IapEvent.purchaseProduct(primaryId));
                      context.pop();
                    },
                  ),
                  TextButton(onPressed: () => _onRestorePurchase(context), child: Text("Restore purchase")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: _openTermsOfUse, child: Text("Terms of use")),
                      TextButton(onPressed: _openPrivacyPolicy, child: Text("Privacy policy")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
    _amplitude.track(BaseEvent('paywall_dialog_open'));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amplitude.track(BaseEvent('paywall_dialog_close'));
    super.dispose();
  }

  void _openTermsOfUse() async {
    final termsOfUseUrl = const String.fromEnvironment("TERMS_OF_USE_URL");
    await launchUrl(Uri.parse(termsOfUseUrl));
  }

  void _openPrivacyPolicy() async {
    final privacyPolicyUrl = const String.fromEnvironment("PRIVACY_POLICY_URL");
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }

  void _onRestorePurchase(BuildContext context) {
    context.read<IapBloc>().add(IapEvent.restorePurchases());
    _amplitude.track(BaseEvent('paywall_dialog_restore_purchase'));
    context.pop();
  }
}
