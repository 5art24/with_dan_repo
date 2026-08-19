// core/widgets/city_area_dropdown_selector.dart

import 'package:flutter/material.dart';
import 'package:project1_collage/core/constants.dart';
import 'package:project1_collage/core/styles.dart';

class CityAreaDropdownSelector extends StatelessWidget {
  final String? selectedCity;
  final String? selectedArea;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onAreaChanged;

  const CityAreaDropdownSelector({
    super.key,
    required this.selectedCity,
    required this.selectedArea,
    required this.onCityChanged,
    required this.onAreaChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cityAreaMap = AppConstants.cityAreaMap;
    final availableAreas = cityAreaMap[selectedCity] ?? [];

    return Column(
      children: [
        // 🏙️ القائمة الأولى: البلد / المدينة الرئيسية
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Styles.mainColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text("اختر البلد / المدينة الرئيسية", style: Styles.body.copyWith(color: Colors.grey)),
              value: cityAreaMap.containsKey(selectedCity) ? selectedCity : null,
              items: cityAreaMap.keys.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city, style: Styles.body),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onCityChanged(val);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 📍 القائمة الثانية: المنطقة / المحافظة الفرعية
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: (selectedCity != null && selectedCity!.isNotEmpty)
                  ? Styles.mainColor.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                (selectedCity == null || selectedCity!.isEmpty)
                    ? "اختر الخيار الأول أولاً"
                    : "اختر المنطقة / المحافظة",
                style: Styles.body.copyWith(color: Colors.grey),
              ),
              value: availableAreas.contains(selectedArea) ? selectedArea : null,
              items: availableAreas.map((String area) {
                return DropdownMenuItem<String>(
                  value: area,
                  child: Text(area, style: Styles.body),
                );
              }).toList(),
              onChanged: (selectedCity == null || selectedCity!.isEmpty)
                  ? null
                  : (val) {
                      if (val != null) onAreaChanged(val);
                    },
            ),
          ),
        ),
      ],
    );
  }
}