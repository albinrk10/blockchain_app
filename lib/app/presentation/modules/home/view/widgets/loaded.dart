import 'package:example2/app/presentation/modules/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeLoaded extends StatelessWidget {
  const HomeLoaded({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = context.watch();
    final state = bloc.state;
    return state.maybeMap(
      loaded: (state) {
        final cryptos = state.cryptos;
        return ListView.builder(
          itemBuilder: (_, index) {
            final crypto = cryptos[index];
            return ListTile(
              title: Text(crypto.id),
              subtitle: Text(crypto.symbol),
              trailing: Text(crypto.price.toStringAsFixed(2)),
            );
          },
          itemCount: cryptos.length,
        );
      },
      orElse: () => const SizedBox(),
    );
  }
}
