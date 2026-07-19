// lib/features/common/widgets/events_grid.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/filtered_event_card.dart';

/// 🔹 Widget لعرض شبكة الفعاليات
/// يدعم نوعين من العرض:
/// 1. GridView.builder (للاستخدام في Column)
/// 2. SliverGrid (للاستخدام في CustomScrollView)
class EventsGrid extends StatelessWidget {
  // ========== البيانات الأساسية ==========
  final List<ConstantEventModel> events;
  final bool isLoading;
  final bool isEmpty;
  final String? emptyMessage;

  // ========== إعدادات الـ Grid ==========
  final int crossAxisCount;
  final double spacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  // ========== التحكم في نوع العرض ==========
  final bool useSliver;

  // ========== Constructor ==========
  const EventsGrid({
    super.key,
    required this.events,
    this.isLoading = false,
    this.isEmpty = false,
    this.emptyMessage = 'No events found',
    this.crossAxisCount = 2,
    this.spacing = 14.0,
    this.padding,
    this.physics,
    this.useSliver = false, // 🔹 افتراضي Normal
  });
  factory EventsGrid.sliver({
    Key? key,
    required List<ConstantEventModel> events,
    bool isLoading = false,
    bool isEmpty = false,
    String? emptyMessage,
    int crossAxisCount = 2,
    double spacing = 14.0,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return EventsGrid(
      key: key,
      events: events,
      isLoading: isLoading,
      isEmpty: isEmpty,
      emptyMessage: emptyMessage,
      crossAxisCount: crossAxisCount,
      spacing: spacing,
      padding: padding,
      physics: physics,
      useSliver: true,
    );
  }

  // 🔹 Factory Constructor للـ Normal
  factory EventsGrid.normal({
    Key? key,
    required List<ConstantEventModel> events,
    bool isLoading = false,
    bool isEmpty = false,
    String? emptyMessage,
    int crossAxisCount = 2,
    double spacing = 14.0,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return EventsGrid(
      key: key,
      events: events,
      isLoading: isLoading,
      isEmpty: isEmpty,
      emptyMessage: emptyMessage,
      crossAxisCount: crossAxisCount,
      spacing: spacing,
      padding: padding,
      physics: physics,
      useSliver: false,
    );
  }
  // ========== دوال مساعدة خاصة ==========

  /// 🔹 حساب أبعاد البطاقة ديناميكياً
  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - (spacing * 2);
    final cardWidth =
        (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
    const cardHeight = 220.0;
    final dynamicAspectRatio = cardWidth / cardHeight;

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: dynamicAspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
    );
  }

  /// 🔹 بناء بطاقة الفعالية
  Widget _buildEventCard(BuildContext context, ConstantEventModel event) {
    return FilteredEventCard(
      event: event,
      onTap: () {
        GoRouter.of(
          context,
        ).push(AppRoutes.kConstantEventDetails, extra: {'event': event});
      },
    );
  }

  /// 🔹 حالة التحميل
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Styles.mainColor),
    );
  }

  /// 🔹 حالة فارغة
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            emptyMessage!,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          if (events.isEmpty && !isLoading) ...[
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
    );
  }

  // ========== بناء GridView العادي ==========
  Widget _buildNormalGrid(BuildContext context) {
    // حالة التحميل
    if (isLoading) {
      return _buildLoadingState();
    }

    // حالة فارغة
    if (isEmpty || events.isEmpty) {
      return _buildEmptyState();
    }

    // GridView.builder
    return GridView.builder(
      key: const Key('events_grid_normal'),
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding ?? const EdgeInsets.all(8),
      gridDelegate: _buildGridDelegate(context),
      itemCount: events.length,
      itemBuilder: (context, index) => _buildEventCard(context, events[index]),
    );
  }

  // ========== بناء SliverGrid ==========
  Widget _buildSliverGrid(BuildContext context) {
    // حالة التحميل
    if (isLoading) {
      return SliverFillRemaining(child: _buildLoadingState());
    }

    // حالة فارغة
    if (isEmpty || events.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    // SliverGrid
    return SliverPadding(
      padding: padding ?? const EdgeInsets.all(8),
      sliver: SliverGrid(
        key: const Key('events_grid_sliver'),
        gridDelegate: _buildGridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildEventCard(context, events[index]),
          childCount: events.length,
        ),
      ),
    );
  }

  // ========== البناء الرئيسي ==========
  @override
  Widget build(BuildContext context) {
    // 🔥 اختيار النوع المناسب
    return useSliver ? _buildSliverGrid(context) : _buildNormalGrid(context);
  }
}
