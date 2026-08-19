// lib/features/search/views/search_results_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/widgets/events_grid.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/search_bar.dart';
import 'package:project1_collage/features/search_results/view_model/search_cubit.dart';
import 'package:project1_collage/features/search_results/view_model/search_state.dart';

class SearchResultsPage extends StatefulWidget {
  final String initialQuery;
  final List<ConstantEventModel>? initialResults;

  const SearchResultsPage({
    super.key,
    required this.initialQuery,
    this.initialResults,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _searchController;
  late final SearchCubit _searchCubit;

  // @override
  // void initState() {
  //   super.initState();
  //   _searchController = TextEditingController(text: widget.initialQuery);
  //   try {
  //     _searchCubit = context.watch<SearchCubit>();
  //   } catch (e) {
  //     // إذا لم يكن موجوداً، ننشئ واحداً جديداً
  //     _searchCubit = SearchCubit();
  //   }
  //   // 🔹 إذا كانت هناك نتائج أولية، استخدمها
  //   if (widget.initialResults != null && widget.initialResults!.isNotEmpty) {
  //     _searchCubit.emit(
  //       SearchLoaded(
  //         results: widget.initialResults!,
  //         query: widget.initialQuery,
  //       ),
  //     );
  //   } else {
  //     _searchCubit.searchEvents(widget.initialQuery);
  //   }
  // }
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchCubit = context.read<SearchCubit>();

    // 🟢 في حال وجود نتائج أولية، نمررها على الكيوبيت ليفلترها بحسب المدينة والمنطقة
    if (widget.initialResults != null && widget.initialResults!.isNotEmpty) {
      _searchCubit.setInitialResults(widget.initialResults!);
    } else {
      _searchCubit.searchEvents(widget.initialQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: ()  {// 🔹 عند العودة، نمسح الـ Cubit إذا كان محلياً
            // if (_searchCubit is SearchCubit) {
              _searchCubit.clear();
            // }
            Navigator.pop(context);
          },
        ),
        title: EventsSearchBar(
          controller: _searchController,
          showLocationButton: false, // إخفاء زر الموقع في صفحة النتائج
          onClear: _handleClear, // معالج مخصص للمسح
          onSearch: (query) {
            // عند البحث من الشريط
            _searchCubit.searchEvents(query);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        bloc: _searchCubit,
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Text(
                'Start typing to search...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
    
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
    
          if (state is SearchLoaded) {
            return EventsGrid(
              events: state.results,
              isLoading: false,
              isEmpty: false,
              crossAxisCount: 2,
              spacing: 14,
              padding: const EdgeInsets.all(16),
            );
          }
    
          if (state is SearchEmpty) {
            return Center(
              child: Text(
                state.query != null
                    ? 'No results found for "${state.query}"'
                    : 'Start typing to search...',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
    
          if (state is SearchError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
    
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // 🔹 معالج مسح النص في صفحة النتائج
  void _handleClear() {
    _searchCubit.clear();
    // العودة إلى الصفحة السابقة (الرئيسية)
    Navigator.pop(context);
  }
}
