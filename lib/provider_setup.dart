import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'auth_service.dart';
import 'theme_manager.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
  ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
];
