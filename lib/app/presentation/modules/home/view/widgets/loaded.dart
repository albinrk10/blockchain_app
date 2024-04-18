import 'package:example2/app/presentation/modules/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const colors = <String , Color>{
  'BTC': Color(0xffF7931A),
  'ETH': Color(0xff627EEA),
  'USDT': Color(0xff26A17B),
  'BNB': Color(0xffF3BA2F),
  'USDC': Color(0xffFF6600),
  'DOGE': Color(0xff2EB67D),
  'LTC': Color(0xff2775CA),
  'XMR': Color(0xffC3A634),
};
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
          padding: const EdgeInsets.all(6),
          itemBuilder: (_, index) {
            final crypto = cryptos[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/${crypto.symbol}.svg',
                      width: 30,
                      height: 30,
                      color: colors[crypto.symbol] ,
                    ),
                  ],
                ),
                title: Text(crypto.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                subtitle: Text(crypto.symbol),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat.currency(name: r'$').format(crypto.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${crypto.changePercent24Hr.toStringAsFixed(2)}%',
                      style: TextStyle(
                          color: crypto.changePercent24Hr.isNegative
                              ? Colors.red
                              : Colors.green),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: cryptos.length,
        );
      },
      orElse: () => const SizedBox(),
    );
  }
}
