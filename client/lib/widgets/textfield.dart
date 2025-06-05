import 'package:flutter/material.dart';

class TextFill extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  const TextFill({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<TextFill> createState() => _TextFillState();
}

class _TextFillState extends State<TextFill> {
  // Fixed: Password should be obscured by default (true), not visible
  bool _isPasswordObscured = true;
  late final TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Initialize controller - use provided one or create new
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    // Set initial password obscured state
    _isPasswordObscured = widget.isPassword;
  }

  @override
  void dispose() {
    // Only dispose controller if we created it internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: TextFormField(
        // Changed to TextFormField for validation support
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        // Fixed: Use _isPasswordObscured for password fields, false for others
        obscureText: widget.isPassword ? _isPasswordObscured : false,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        textInputAction: widget.textInputAction,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          fillColor: const Color(0xffF3F6FB),
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: widget.prefixIcon,

          // Fixed: Handle suffix icon logic properly
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    icon: Icon(
                      // Fixed: Show eye-off when password is obscured, eye when visible
                      _isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  )
                  : widget.suffixIcon,

          // Improved border styling
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),

          // Consistent padding
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          // Error text styling
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),

        // Callbacks
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
      ),
    );
  }
}
