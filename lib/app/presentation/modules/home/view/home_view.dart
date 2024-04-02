import 'package:example2/app/presentation/modules/home/bloc/home_bloc.dart';
import 'package:example2/app/presentation/modules/home/view/widgets/app_bar.dart';
import 'package:example2/app/presentation/modules/home/view/widgets/error.dart';
import 'package:example2/app/presentation/modules/home/view/widgets/loaded.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeBloc(
        exchangeRepository: context.read(),
        wsRepository: context.read(),
      )..init(),
      builder: (context, _) {
        final HomeBloc bloc = context.watch();
        return Scaffold(
            appBar: const HomeAppBar(),
            body: bloc.state.map(
                loading: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                failed: (_) => const HomeError(),
                loaded: (_) => const HomeLoaded(),
                    ));
      },
    );
  }
}
