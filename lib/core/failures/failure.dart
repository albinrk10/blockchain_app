sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No se pudo conectar a la red. Revisa tu conexión.']);
}

final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    this.statusCode,
    String? message,
  }) : super(message ?? 'Error en el servidor de CoinCap ($statusCode).');
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Los recursos solicitados no fueron encontrados.']);
}

final class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Error al procesar los datos de las criptomonedas.']);
}

final class WebSocketFailure extends Failure {
  const WebSocketFailure([super.message = 'Error en el canal de WebSocket en tiempo real.']);
}

final class UnexpectedFailure extends Failure {
  final Object? error;
  const UnexpectedFailure([this.error, super.message = 'Ocurrió un error inesperado.']);
}
