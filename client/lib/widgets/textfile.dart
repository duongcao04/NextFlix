import 'package:flutter/material.dart';

class TextFill extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const TextFill({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TextFillState createState() => _TextFillState();
}

class _TextFillState extends State<TextFill> {
  bool _isPasswordVisible = true;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Nếu controller bên ngoài truyền vào null thì tạo controller mới bên trong
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Nếu controller là của widget tạo ra thì mới dispose để tránh dispose controller truyền từ ngoài
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: TextField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _isPasswordVisible : false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          fillColor: const Color(0xffF3F6FB),
          filled: true,
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
