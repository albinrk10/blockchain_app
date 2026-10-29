import 'package:flutter/material.dart';

class CryptoSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CryptoSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Buscar por nombre o símbolo (ej. BTC)...',
  });

  @override
  State<CryptoSearchBar> createState() => _CryptoSearchBarState();
}

class _CryptoSearchBarState extends State<CryptoSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
              )
            : null,
      ),
    );
  }
}
