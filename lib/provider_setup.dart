import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'auth_service.dart';
import 'order_service.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
  ChangeNotifierProvider<OrderService>(create: (_) => OrderService()),
];
