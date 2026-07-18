
export 'package:equatable/equatable.dart';
// `test` is hidden: injectable's environment-annotation helper collides
// with flutter_test's test() whenever a test file imports both.
export 'package:injectable/injectable.dart' hide test;

export 'src/presentation/dialogs/error_dialog.dart';
export 'src/error/failure.dart';
export 'src/navigation/app_routes.dart';
export 'src/navigation/navigation_service.dart';
export 'src/network/base_api_client.dart';
export 'src/network/api_exception_handler.dart';
export 'config/env.dart';
export 'src/config/app_config.dart';
export 'src/location/coordinates.dart';
export 'src/location/location_service.dart';
