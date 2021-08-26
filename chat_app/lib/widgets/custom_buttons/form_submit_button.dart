import 'package:chat_app/widgets/custom_buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    Key? key,
    required String text,
    bool loading = false,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          textColor: Colors.black87,
          loading: loading,
          onPressed: onPressed,
        );
}
