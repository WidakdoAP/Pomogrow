import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:pomogrow/core/theme/app_pallete.dart';

class FlushbarNotif {
  static void show(
    BuildContext context, {
    required String title,
    required String msg,
  }) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      messageText: Text(msg, style: Theme.of(context).textTheme.bodyMedium),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
      backgroundGradient: LinearGradient(
        colors: [
          AppPallete.gradient3,
          AppPallete.gradient2,
          AppPallete.gradient1,
        ],
      ),
    )..show(context);
  }
}
