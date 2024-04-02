import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/home_bloc.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = context.watch<HomeBloc>();
    return AppBar(
      title: bloc.state.mapOrNull(
        loaded: (state) => Text(
          state.wsStatus.when(
            connecting: () => 'conectando...',
            connected: () => 'conectado',
            failed: () => 'failed',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}