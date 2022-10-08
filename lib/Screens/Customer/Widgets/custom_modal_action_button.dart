import 'package:autoassist/Screens/Customer/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CustomModalActionButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;

  const CustomModalActionButton({required this.onClose, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomButton(
          color: Colors.indigo,
          textColor: Colors.white,
          onPressed: onClose,
          buttonText: "Close",
        ),
        CustomButton(
          onPressed: onSave,
          buttonText: "Update",
          color: Theme.of(context).colorScheme.secondary,
          textColor: Colors.white,
        )
      ],
    );
  }
}
