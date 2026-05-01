import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/partners_screen.dart';
import '../screens/partner_detail_screen.dart';
import '../screens/inquiry_screen.dart';
import '../screens/inquiry_list_screen.dart';
import '../screens/inquiry_detail_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/studio_screen.dart';
import '../screens/studio_export_screen.dart';
import '../screens/studio_bg_screen.dart';
import '../screens/record_screen.dart';
import '../screens/community_screen.dart';
import '../screens/community_post_screen.dart';
import '../screens/community_compose_screen.dart';
import '../screens/archive_screen.dart';
import '../screens/archive_manual_screen.dart';
import '../screens/archive_sync_screen.dart';
import '../screens/archive_scan_screen.dart';
import '../screens/archive_ai_screen.dart';
import 'bottom_nav.dart';
import 'status_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _hiddenNav = {'splash', 'login', 'signup', 'studio', 'studioExport', 'studioBg', 'archiveAI'};
  static const _darkStatus = {'splash', 'studioExport', 'communityPost', 'profile'};

  Widget _buildScreen(String route) {
    final parts = route.split(':');
    final base = parts.first;
    final arg = parts.length > 1 ? parts.sublist(1).join(':') : null;
    switch (base) {
      case 'splash':
        return const SplashScreen();
      case 'login':
        return const LoginScreen();
      case 'signup':
        return const SignupScreen();
      case 'home':
        return const HomeScreen();
      case 'profile':
        return const ProfileScreen();
      case 'profileEdit':
        return const ProfileEditScreen();
      case 'settings':
        return const SettingsScreen();
      case 'partners':
        return const PartnersScreen();
      case 'partnerDetail':
        return PartnerDetailScreen(id: arg ?? 'ntc');
      case 'inquiry':
        return const InquiryScreen();
      case 'inquiryList':
        return const InquiryListScreen();
      case 'inquiryDetail':
        return InquiryDetailScreen(id: int.tryParse(arg ?? '0') ?? 0);
      case 'feedback':
        return const FeedbackScreen();
      case 'studio':
        return const StudioScreen();
      case 'studioExport':
        return const StudioExportScreen();
      case 'studioBg':
        return const StudioBgScreen();
      case 'record':
        return const RecordScreen();
      case 'community':
        return const CommunityScreen();
      case 'communityPost':
        return CommunityPostScreen(id: int.tryParse(arg ?? '1') ?? 1);
      case 'communityCompose':
        return const CommunityComposeScreen();
      case 'archive':
        return const ArchiveScreen();
      case 'archiveManual':
        return const ArchiveManualScreen();
      case 'archiveSync':
        return const ArchiveSyncScreen();
      case 'archiveScan':
        return const ArchiveScanScreen();
      case 'archiveAI':
        return const ArchiveAiScreen();
      default:
        return const Center(child: Text('준비 중'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavController>();
    final route = nav.top;
    final base = route.split(':').first;
    final showNav = !_hiddenNav.contains(base);
    final isDark = _darkStatus.contains(base);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (nav.length > 1) {
          context.read<NavController>().back();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              FakeStatusBar(foreground: isDark ? Colors.white : AppColors.textPrimary),
              Expanded(child: _buildScreen(route)),
              if (showNav) const BottomNav(),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
