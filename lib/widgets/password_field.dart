import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Password box with a show/hide toggle. Reveal state is per field.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final List<String> autofillHints;
  final TextInputAction textInputAction;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onFieldSubmitted,
    this.autofillHints = const [],
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_visible,
      // Flutter only disables these while obscured, not once revealed.
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: context.colors.textSecondary,
          ),
          tooltip: _visible ? 'Hide password' : 'Show password',
          onPressed: () => setState(() => _visible = !_visible),
        ),
      ),
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
