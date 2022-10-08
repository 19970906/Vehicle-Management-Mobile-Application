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
          onPressed: onClose,
          buttonText: "Close",
          color: Colors.indigo,
          textColor: Colors.white,
        ),
        CustomButton(
          onPressed: onSave,
          buttonText: "Save",
          color: Theme.of(context).colorScheme.secondary,
          textColor: Colors.white,
        )
      ],
    );
  }
}
