import 'package:event_app/core/providers/app_configprovider.dart';
import 'package:event_app/core/theme/app_theme.dart';
import 'package:event_app/core/ui/auth/login/forget_password_screen.dart';
import 'package:event_app/core/ui/auth/login/login_screen.dart';
import 'package:event_app/core/ui/auth/register/register_screen.dart';
import 'package:event_app/core/ui/home/tabs/home/add_event/add_even_screen.dart';
import 'package:event_app/core/ui/home/home_screen.dart';
import 'package:event_app/core/ui/home/tabs/home/event_details/event_details.dart';
import 'package:event_app/core/ui/home/tabs/mabs/mab_tab.dart';
import 'package:event_app/core/ui/onpoarding/export_app.dart';
import 'package:event_app/core/ui/onpoarding/onpoarding_screen.dart';
import 'package:event_app/core/ui/splash_screen/splash_screen.dart';
import 'package:event_app/firebase_options.dart';
import 'package:event_app/l10n/translations/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppConfigprovider(),
        ),
      ],
    child:  MyApp())
    );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
   MyApp({super.key});
   //create Refrance 
  late AppConfigprovider appConfigprovider;

  @override
  Widget build(BuildContext context) {

    //اول ما يحصل ابديت في ال AppConfig يروح يبص علي الريفرنس ويعمل ابديت فيه ويعمل ري بيلد
    appConfigprovider =Provider.of<AppConfigprovider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appConfigprovider.themeMode,
      localizationsDelegates:AppLocalizations.localizationsDelegates,
       supportedLocales:AppLocalizations.supportedLocales ,
       locale: Locale(appConfigprovider.locale),
       
  
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        OnpoardingScreen.routeName :(context) => const OnpoardingScreen(),
        ExportApp.routeName:(context)=> ExportApp(),
        LoginScreen.routeName:(context)=>LoginScreen(),
        SingupScreen.routeName:(context)=>SingupScreen(),
        ForgetPasswordScreen.routeName:(context)=>ForgetPasswordScreen(),
        HomeScreen.routeName:(context)=>HomeScreen(),
        EventManagementScreen.routeName:(context)=>EventManagementScreen(),
        MapTab.routeName:(context)=>MapTab(),
        EventDetails.routeName:(context)=>EventDetails()
        
      },
      initialRoute: LoginScreen.routeName,
    
    );
  }
}
