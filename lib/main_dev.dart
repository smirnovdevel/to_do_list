import 'flavors.dart';

import 'main.dart' as runner;

void main() async {
  F.appFlavor = Flavor.dev;
  runner.main();
}
