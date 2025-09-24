library config.globals;
import 'package:ziarul_argesul/services/persistent_notification_choice.dart';
import 'package:ziarul_argesul/theme/app_theme.dart';
import 'package:hive/hive.dart';

/// Instance of the AppTheme used throughout the app.
AppTheme appTheme = AppTheme();
/// We also keep track of the notifications selection, so it can persist after
/// an app restart.
Notifications notifications = Notifications();
/// Box/Hive global instance.
Box? box;

Box? articleBox;