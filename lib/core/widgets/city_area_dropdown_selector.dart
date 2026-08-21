// core/widgets/city_area_dropdown_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/location/location_cubit.dart';

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
    final locationState = context.watch<LocationCubit>().state;

    // 🔄 حالة التحميل
    if (locationState is LocationLoading || locationState is LocationInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    // ⚠️ حالة الخطأ
    if (locationState is LocationError) {
      return Text(
        locationState.error,
        style: Styles.body.copyWith(color: Colors.red),
      );
    }

    // ✅ البيانات جاهزة
    final countriesData = (locationState as LocationLoaded).countriesData;
    final availableAreas = countriesData[selectedCity] ?? [];

    return Column(
      children: [
        // 🏙️ القائمة الأولى: الدولة
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
              value: countriesData.containsKey(selectedCity) ? selectedCity : null,
              items: countriesData.keys.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country, style: Styles.body),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onCityChanged(val);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 📍 القائمة الثانية: المدينة/المنطقة
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