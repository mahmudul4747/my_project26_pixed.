import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool loading;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,

      child: ElevatedButton(
        onPressed: loading ? null : onTap,

        child: loading
            ? const CircularProgressIndicator()
            : Text(title),
      ),
    );
  }
}