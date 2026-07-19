import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/widgets/events_grid.dart';
import 'package:project1_collage/features/explore_constant_events/view_model/explore_constant_events_cubit.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/search_bar.dart';
import 'package:project1_collage/features/search_results/view_model/search_cubit.dart';
import 'package:project1_collage/features/search_results/view_model/search_state.dart';
import 'widgets/category_filter_chips.dart';
import 'widgets/section_header.dart';
import 'widgets/happening_soon_event_card.dart';

class ExploreConstantEventsBody extends StatelessWidget {
  const ExploreConstantEventsBody({super.key});

  @override
  Widget build(BuildContext context) {
    // تحميل البيانات عند بناء الـ Widget لأول مرة
    // باستخدام BlocListener لتنفيذ الـ init مرة واحدة فقط
    return BlocListener<ExploreConstantEventsCubit, ExploreConstantEventsState>(
      listener: (context, state) {
        // تنفيذ الـ init فقط إذا كانت الحالة Initial
        if (state is ExploreConstantEventsInitial) {
          context.read<ExploreConstantEventsCubit>().loadEvents();
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ==============================search bar===============================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: EventsSearchBar(
                    showLocationButton: true,
                    onSearch: (query) {
                      final searchCubit = context.read<SearchCubit>();
                      searchCubit.searchEvents(query);
                      final state = searchCubit.state;
                      List<ConstantEventModel> results = [];
                      if (state is SearchLoaded) {
                        results = state.results;
                      }

                      GoRouter.of(context).push(
                        AppRoutes.kSearchResults,
                        extra: {
                          'initialQuery': query,
                          'initialResults': results,
                          'cubit': searchCubit,
                        },
                      );
                    },
                    onClear: () {
                      context.read<SearchCubit>().clear();
                    },
                  ),
                ),
              ),

              // Happening Soon header
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: "Happening Soon",
                  onSeeAllTap: () {},
                  seeAllExist: true,
                ),
              ),

              // Horizontal List for Happening Soon event
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      ConstantEventModel event = ConstantEventModel(
                        id: 'feat_$index',
                        name: 'National Music Festival',
                        accommodation: 500,
                        date: DateTime(2026, 12, 24),
                        bookings: const [],
                        imageUrl: const ['https://picsum.photos/400/250'],
                        location: 'GrandPark, New York',
                        type: EventType.music,
                        description: 'Festival description goes here...',
                      );
                      return HappeningSoonEventCard(
                        event: event,
                        onTap: () => GoRouter.of(context).push(
                          AppRoutes.kConstantEventDetails,
                          extra: {'event': event},
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Categories filters
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: "Categories",
                      onSeeAllTap: () {},
                      seeAllExist: false,
                    ),
                    const CategoryFilterChips(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              
              // ========== عرض الفعاليات المفلترة ==========
              BlocBuilder<ExploreConstantEventsCubit, ExploreConstantEventsState>(
                builder: (context, state) {
                  if (state is ExploreConstantEventsLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  
                  if (state is ExploreConstantEventsError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  if (state is ExploreConstantEventsLoaded) {
                    if (state.events.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No events found in this category',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return EventsGrid.sliver(
                      events: state.events,
                      crossAxisCount: 2,
                      spacing: 14,
                      padding: const EdgeInsets.only(top: 8),
                    );
                  }
                  
                  // حالة ExploreConstantEventsInitial - لا نعرض أي شيء حتى يقوم الـ BlocListener بتحميل البيانات
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}