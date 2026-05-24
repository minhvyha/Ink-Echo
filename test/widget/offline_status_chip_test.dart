import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/services/connectivity_service.dart';
import 'package:inkandecho/widgets/offline_status_chip.dart';

import '../helpers/test_helpers.dart';

void main() {
  testWidgets('shows Offline label when connectivity is offline', (tester) async {
    ConnectivityService.instance.setOnlineForTesting(false);
    addTearDown(() => ConnectivityService.instance.setOnlineForTesting(true));

    await tester.pumpWidget(
      wrapWithInkEchoTheme(const OfflineStatusChip()),
    );
    await tester.pump();

    expect(find.text('Offline'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
  });

  testWidgets('hides when online', (tester) async {
    ConnectivityService.instance.setOnlineForTesting(true);

    await tester.pumpWidget(
      wrapWithInkEchoTheme(const OfflineStatusChip()),
    );
    await tester.pump();

    expect(find.text('Offline'), findsNothing);
  });
}
