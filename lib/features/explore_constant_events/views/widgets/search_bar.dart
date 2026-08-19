// lib/features/explore_constant_events/views/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/city_area_dropdown_selector.dart';
import 'package:project1_collage/features/explore_constant_events/view_model/explore_constant_events_cubit.dart';
import 'package:project1_collage/features/search_results/view_model/search_cubit.dart';
import 'package:project1_collage/features/search_results/view_model/search_state.dart';

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
      widget.onSearch?.call(query);
    }
  }

  void _clearText() {
    _searchController.clear();
    setState(() {
      _hasText = false;
    });
    widget.onTextChanged?.call('');

    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  // 🟢 دالة فتح الـ Bottom Sheet
  void _showLocationBottomSheet(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final exploreCubit = context.read<ExploreConstantEventsCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return CityAreaDropdownSelector(
              selectedCity: searchCubit.selectedCity,
              selectedArea: searchCubit.selectedArea,
              onCityChanged: (city) {
                setModalState(() {
                  searchCubit.updateCity(city);
                  exploreCubit.updateLocation(
                    searchCubit.selectedCity,
                    searchCubit.selectedArea,
                  );
                });
              },
              onAreaChanged: (area) {
                setModalState(() {
                  searchCubit.updateArea(area);
                  exploreCubit.updateLocation(
                    searchCubit.selectedCity,
                    searchCubit.selectedArea,
                  );
                });
              },
            );
          },
        );
      },
    );
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
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    final searchCubit = context.read<SearchCubit>();
                    final exploreCubit = context.read<ExploreConstantEventsCubit>();
                    
                    // 🟢 يكون الفلتر مفعل إذا كان المبدال مفعلاً وهناك مدينة مختارة
                    final isFilterActive = searchCubit.isLocationFilterEnabled && 
                                           searchCubit.selectedCity.isNotEmpty;

                    return IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: isFilterActive
                            ? Styles.mainColor
                            : Colors.grey.shade400,
                      ),
                      tooltip: isFilterActive ? 'إلغاء الفلتر' : 'تحديد موقع',
                      onPressed: () {
                        if (isFilterActive) {
                          // 🔴 1. إذا كان الفلتر مفعل وضغطنا عليه:
                          // نمسح الموقع ونعطله لتعود البيانات غير مفلترة ويصبح الزر رمادياً
                          searchCubit.clearLocation();
                          exploreCubit.updateLocation('', '');
                        } else {
                          // 🟢 2. إذا كان الفلتر غير مفعل (رمادي) وضغطنا عليه:
                          // نفتح دائماً الـ Bottom Sheet لإتاحة اختيار جديد
                          _showLocationBottomSheet(context);
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}