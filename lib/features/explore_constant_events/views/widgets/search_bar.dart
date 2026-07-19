// lib/features/explore_constant_events/views/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';

class EventsSearchBar extends StatefulWidget {
  final Function(String)? onSearch;
  final Function(String)? onTextChanged;
  final TextEditingController? controller;
  final bool showLocationButton;
  final VoidCallback? onClear;

  const EventsSearchBar({
    super.key,
    this.onSearch,
    this.onTextChanged,
    this.controller,
    this.showLocationButton = true,
    this.onClear,
  });

  @override
  State<EventsSearchBar> createState() => _EventsSearchBarState();
}

class _EventsSearchBarState extends State<EventsSearchBar> {
  late final TextEditingController _searchController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();
    _hasText = _searchController.text.isNotEmpty;
    _searchController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(EventsSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _searchController.removeListener(_onTextChanged);
      _searchController.text = widget.controller?.text ?? '';
      _hasText = _searchController.text.isNotEmpty;
      _searchController.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    } else {
      _searchController.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _searchController.text;
    setState(() {
      _hasText = text.isNotEmpty;
    });
    widget.onTextChanged?.call(text);
  }

  void _triggerSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch?.call(query); // فقط الـ callback
    }
  }

  void _clearText() {
    _searchController.clear();
    setState(() {
      _hasText = false;
    });
    widget.onTextChanged?.call('');
    
    // استدعاء onClear المخصص
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        cursorColor: Styles.mainColor,
        textInputAction: TextInputAction.search,
        onChanged: (value) => _triggerSearch(),
        onSubmitted: (_) => _triggerSearch(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: IconButton(
            icon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
            onPressed: _triggerSearch,
          ),
          hintText: "What event are you looking for...",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasText)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  onPressed: _clearText,
                ),
              if (widget.showLocationButton)
                GestureDetector(
                  onTap: () {
                    // TODO: تنفيذ اختيار الموقع
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Styles.mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}