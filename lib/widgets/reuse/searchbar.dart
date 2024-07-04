import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar ({
    super.key,
    this.controller,
    this.focusNode,
    this.leading,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.backgroundColor, 
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.padding,
    this.textStyle,
    this.hintText,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? leading;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? overlayColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final String? hintText;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return Container(
      constraints: widget.constraints,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFFF6F6F6),
        boxShadow: [
          if(widget.shadowColor != null)
          BoxShadow(
            color: widget.shadowColor!,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: widget.textStyle,
        decoration: InputDecoration(
          hintText: widget.hintText ?? '토론 검색어를 입력하세요',
          border: InputBorder.none,
          prefixIcon: widget.leading,
          filled: true,
          fillColor: widget.surfaceTintColor ?? Colors.white, 
        ),
      ),
    );
  }
}