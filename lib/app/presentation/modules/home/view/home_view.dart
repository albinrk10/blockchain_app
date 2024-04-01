import 'package:example2/app/presentation/modules/home/bloc/home_bloc.dart';
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
            appBar: AppBar(
                title: bloc.state.mapOrNull(
              loaded: (state) => Text(
                state.wsStatus.when(
                  connecting:() =>  'connecting',
                  connected:() => 'connected',
                  failed:() => 'failed',
                ),
              ),
            )),
            body: bloc.state.map(
                loading: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                failed: (state) {
                  final message = state.failure.whenOrNull(
                    network: () => 'Network error',
                    server: () => 'Server error',
                  );
                  if (message == null) {
                    return const SizedBox();
                  }
                  return Center(
                    child: Text(message),
                  );
                },
                loaded: (state) => ListView.builder(
                      itemBuilder: (_, index) {
                        final crypto = state.cryptos[index];
                        return ListTile(
                          title: Text(crypto.id),
                          subtitle: Text(crypto.symbol),
                          trailing: Text(crypto.price.toStringAsFixed(2)),
                        );
                      },
                      itemCount: state.cryptos.length,
                    )));
      },
    );
  }
}
