// ignore_for_file: type=lint, invalid_use_of_internal_member

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:patrol/src/platform/contracts/contracts.dart';

// START: GENERATED TEST IMPORTS
import 'F:/Programming/Flutter/magoosh_gre_app_clone/integration_test/app_test.dart' as F:__Programming__Flutter__magoosh_gre_app_clone__integration_test__app_test;
// END: GENERATED TEST IMPORTS

Future<void> main() async {
  final platformAutomator = PlatformAutomator(
    config: PlatformAutomatorConfig.defaultConfig(),
  );
  await platformAutomator.initialize();
  
  PatrolBinding.ensureInitialized(platformAutomator)
    ..workaroundDebugDefaultTargetPlatformOverride =
        debugDefaultTargetPlatformOverride;

  // START: GENERATED TEST GROUPS
  group('F:.Programming.Flutter.magoosh_gre_app_clone.integration_test.app_test', F:__Programming__Flutter__magoosh_gre_app_clone__integration_test__app_test.main);
  // END: GENERATED TEST GROUPS
}
