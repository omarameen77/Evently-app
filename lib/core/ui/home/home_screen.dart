import 'package:event_app/core/providers/app_configprovider.dart';
import 'package:event_app/core/theme/app_color.dart';
import 'package:event_app/core/ui/home/tabs/home/events_manege/event_manage_screen.dart';
import 'package:event_app/core/ui/home/tabs/fav/fav_tab.dart';
import 'package:event_app/core/ui/home/tabs/home/home_tab.dart';
import 'package:event_app/core/ui/home/tabs/mabs/mab_tab.dart';
import 'package:event_app/core/ui/home/tabs/profile/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "Home Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [HomeTab(), MapTab(), FavoriteTab(), ProfileTab()];
  @override
  Widget build(BuildContext context) {
    var appConfigProvider = Provider.of<AppConfigprovider>(context);
    return Scaffold(
      body: Column(children: [Expanded(child: tabs[selectedIndex])]),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, EventManagementScreen.routeName);
            return;
          }
          if (index == 3 || index == 4) {
            index--;
          }
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex < 2 ? selectedIndex : selectedIndex + 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.safe_home_outline),
            activeIcon: Icon(Iconsax.home_bold),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.location_outline),
            activeIcon: Icon(Iconsax.location_bold),
            label: "Maps",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: appConfigProvider.isDark()
                  ? AppColors.darkPurple
                  : AppColors.purple,
            ),
            activeIcon: Icon(
              Icons.add,
              color: appConfigProvider.isDark()
                  ? AppColors.darkPurple
                  : AppColors.purple,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart_add_outline),
            activeIcon: Icon(Iconsax.heart_add_bold),
            label: "Favorite",
          ),

          BottomNavigationBarItem(
            icon: Icon(Iconsax.user_outline),
            activeIcon: Icon(Iconsax.user_bold),
            label: "Profile",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: appConfigProvider.isDark()
            ? AppColors.darkPurple
            : AppColors.purple,
        onPressed: () {
          Navigator.pushNamed(context, EventManagementScreen.routeName);
        },
        elevation: 0,
        shape: CircleBorder(
          side: BorderSide(width: 4, color: AppColors.offWhite),
        ),
        child: Icon(
          Iconsax.add_outline,
          color: appConfigProvider.isDark()
              ? AppColors.lightBlue
              : AppColors.offWhite,
        ),
      ),
    );
  }
}
