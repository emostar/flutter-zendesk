import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zendesk/zendesk.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sets visitor info', (WidgetTester tester) async {
    await Zendesk().init('ABC');
    
    await Zendesk().setVisitorInfo(
      name: 'some-user',
      email: 'email@domain.com',
      phoneNumber: '12341234',
    );
  });
}
