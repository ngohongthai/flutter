import 'package:chat_app/app/onboarding/onboarding_view_model.dart';
import 'package:chat_app/widgets/custom_buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingView extends StatelessWidget {
  Future<void> onGetStarted(BuildContext context) async {
    final onboardingViewModel =
        context.read(onboardingViewModelProvider.notifier);
    await onboardingViewModel.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Track your time.\nBecause time counts.',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: SvgPicture.asset('assets/time-tracking.svg',
                  semanticsLabel: 'Time tracking logo'),
            ),
            CustomElevatedButton(
              onPressed: () => onGetStarted(context),
              color: Colors.indigo,
              borderRadius: 30,
              child: Text(
                'Get Started',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
