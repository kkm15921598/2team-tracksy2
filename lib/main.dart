import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'shell/app_shell.dart';
import 'state/ai_store.dart';
import 'state/archive_store.dart';
import 'state/community_store.dart';
import 'state/inquiry_store.dart';
import 'state/nav_controller.dart';
import 'state/studio_store.dart';
import 'state/user_store.dart';
import 'theme/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const TracksyApp());
}

class TracksyApp extends StatelessWidget {
  const TracksyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavController()),
        ChangeNotifierProvider(create: (_) => UserStore()),
        ChangeNotifierProvider(create: (_) => ArchiveStore()),
        ChangeNotifierProvider(create: (_) => StudioStore()),
        ChangeNotifierProvider(create: (_) => CommunityStore()),
        ChangeNotifierProvider(create: (_) => AiStore()),
        ChangeNotifierProvider(create: (_) => InquiryStore()),
      ],
      child: MaterialApp(
        title: 'TRACKSY',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}
