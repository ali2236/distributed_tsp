

import 'package:tsp_base/src/algorithms/coordinator/coordinator_sa.dart';

import 'coordinator_default.dart';

export 'coordinator.dart';
export 'coordinator_default.dart';
export 'coordinator_sa.dart';

const coordinators = {
  'Custom' : DefaultCoordinator,
  'DSA' : SACoordinator,
};