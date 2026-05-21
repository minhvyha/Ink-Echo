import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/services/connectivity_service.dart';

void main() {
  tearDown(() async {
    await ConnectivityService.instance.disposeForTesting();
  });

  test('setOnlineForTesting updates isOnline and stream', () async {
    ConnectivityService.instance.setOnlineForTesting(true);
    final events = <bool>[];
    final sub = ConnectivityService.instance.onOnlineChanged.listen(events.add);
    await Future<void>.delayed(Duration.zero);

    ConnectivityService.instance.setOnlineForTesting(false);
    await Future<void>.delayed(Duration.zero);
    expect(ConnectivityService.instance.isOnline, isFalse);

    ConnectivityService.instance.setOnlineForTesting(true);
    await Future<void>.delayed(Duration.zero);
    expect(ConnectivityService.instance.isOnline, isTrue);
    expect(events.first, isTrue);
    expect(events, containsAll([false, true]));

    await sub.cancel();
  });
}
