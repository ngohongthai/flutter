import 'package:chat_app/services/top_level_provider.dart';
import 'package:chat_app/widgets/empty_content/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  const AuthWidget({
    Key? key,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final autheStateChanges = watch(authStateChangesProvider);
    return autheStateChanges.when(
        data: (user) => user == null
            ? nonSignedInBuilder(context)
            : signedInBuilder(context),
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        error: (error, stackTrace) => const Scaffold(
              body: EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load data right now.',
              ),
            ));
  }
}
