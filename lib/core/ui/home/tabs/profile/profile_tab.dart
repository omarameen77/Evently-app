import 'package:event_app/core/providers/app_configprovider.dart';
import 'package:event_app/core/theme/app_color.dart';
import 'package:event_app/core/ui/auth/login/login_screen.dart';
import 'package:event_app/core/ui/home/tabs/profile/widget/imagewithcamera.dart';
import 'package:event_app/core/ui/home/tabs/profile/widget/switchbuttonui.dart';
import 'package:event_app/core/widgets/language_switch.dart';
import 'package:event_app/core/widgets/theme_switch.dart';
import 'package:event_app/data/firebase/firebase_auth.dart';
import 'package:event_app/l10n/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    var appConfigProvider = Provider.of<AppConfigprovider>(context);
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: appConfigProvider.isDark()
                    ? [
                        AppColors.darkPurple,
                        AppColors.darkPurple.withOpacity(0.8),
                      ]
                    : [AppColors.purple, AppColors.purple.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 60),
              child: Imagewithcamera(),
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          // Language Setting
          SwitchButtonui(
            switchType: LangSwitch(),
            title: AppLocalizations.of(context)!.language,
            icon: Icons.language,
          ),
          SizedBox(height: height * 0.02),
          // Theme Setting
          SwitchButtonui(
            switchType: ThemeSwitch(),
            title: AppLocalizations.of(context)!.theme,
            icon: Icons.dark_mode,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 240),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () async {
                  await FirebaseAuthService.signOut();
                  Navigator.pushReplacementNamed(
                    context,
                    LoginScreen.routeName,
                  );
                },
                icon: const Icon(Icons.logout),
                label: Text(
                  AppLocalizations.of(context)!.logout,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
