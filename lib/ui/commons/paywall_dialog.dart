import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/utils/extensions/list_extension.dart';

import '../../generated/assets.dart';
import '../blocs/iap/iap_bloc.dart';
import 'paywall_button.dart';
import 'paywall_page.dart';

class PaywallDialog extends StatefulWidget {
  const PaywallDialog({super.key});

  @override
  State<PaywallDialog> createState() => _PaywallDialogState();
}

class _PaywallDialogState extends State<PaywallDialog> {
  static const primaryId = String.fromEnvironment("PRIMARY_PRODUCT_ID");
  static const secondaryId = String.fromEnvironment("SECONDARY_PRODUCT_ID");

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
                PaywallButton(
                  name: "1 Day No Ads",
                  description: "+1 day use app without ads",
                  price: secondaryPrice,
                  onTap: () {
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
                    context.read<IapBloc>().add(IapEvent.purchaseProduct(primaryId));
                    context.pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
