import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
class BackAndFavoriteButton extends StatelessWidget {
  final ServiceModel? service; // 👈 جعله اختياري (Nullable)

  const BackAndFavoriteButton({
    super.key,
    this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.maybePop(context),
          ),
          
          // 👈 يظهر زر المفضلة فقط إذا كانت الخدمة متوفرة وليست null
          if (service != null)
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final authCubit = context.read<AuthCubit>();
                final isFav = authCubit.isServiceFavorite(service!.id);

                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    authCubit.toggleFavoriteService(service!);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}