import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/service_card.dart';

class FavoriteServicesPageBody extends StatelessWidget {
  const FavoriteServicesPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Services', style: Styles.largeTitle),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final authCubit = context.read<AuthCubit>();
          final favoriteServices = authCubit.currentNormalUser?.favoriteServices ?? [];

          // حالة عدم وجود عناصر بالمفضلة
          if (favoriteServices.isEmpty) {
            return const Center(
              child: Text(
                'No favorite services added yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // بناء الشبكة بنفس الكود والمتغيرات الحسابية
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    const crossAxisCount = 2;
                    const spacing = 14.0;

                    // حساب المساحة المتاحة بدقة
                    final availableWidth = constraints.crossAxisExtent - spacing;
                    final cardWidth = availableWidth / crossAxisCount;
                    const cardHeight = 230.0;
                    final dynamicAspectRatio = cardWidth / cardHeight;

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: dynamicAspectRatio,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final service = favoriteServices[index];
                          return ServiceCard(
                            service: service,
                            isSelectionMode: false,
                            isSelected: false,
                            onTap: () {
                              GoRouter.of(context).push(
                                AppRoutes.kServiceDetails,
                                extra: {'service': service},
                              );
                            },
                          );
                        },
                        childCount: favoriteServices.length,
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}