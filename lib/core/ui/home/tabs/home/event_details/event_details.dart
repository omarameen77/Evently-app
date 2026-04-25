import 'package:event_app/core/models/category_model.dart';
import 'package:event_app/core/models/event.dart';
import 'package:event_app/core/providers/app_configprovider.dart';
import 'package:event_app/core/theme/app_color.dart';
import 'package:event_app/core/ui/home/tabs/home/view_model/home_view_model.dart';
import 'package:event_app/core/ui/home/tabs/home/widgets/custom_container.dart';
import 'package:event_app/core/utils/extintions.dart';
import 'package:event_app/l10n/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatefulWidget {
  static const String routeName = "/eventDetails";
  const EventDetails({super.key});
  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(body: Center(child: Text("No Event Data")));
    }

    final Event event = args["event"];
    final Category category = args["category"];

    var appConfigProvider = Provider.of<AppConfigprovider>(context);
    var height = MediaQuery.of(context).size.height;
    var localization = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    String dateText = "";
    String timeText = "";

    if (event.eventDate != null) {
      dateText = event.eventDate!.formatDate("dd MMM yyyy");
      timeText = event.eventDate!.formatDate("hh:mm a");
    }
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: appConfigProvider.isDark()
                ? theme.colorScheme.surface
                : theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                localization.eventDetails,
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: AppColors.purple,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      category.imagePath,
                      height: height * 0.3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🏷️ Title
                  Center(
                    child: Text(
                      event.title ?? "No Title",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomContainer(
                    title: dateText.isNotEmpty ? dateText : "No Date",
                    subtitle: timeText.isNotEmpty ? timeText : null,
                    icon: Icons.calendar_month_outlined,
                  ),

                  SizedBox(height: height * 0.02),

                  // 📍 Location
                  CustomContainer(
                    title: event.location ?? "Cairo - Egyp",
                    icon: Icons.location_on_outlined,
                    showArrow: true,
                  ),

                  SizedBox(height: height * 0.02),

                  // 🗺️ Map Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/images/Frame.png",
                      height: height * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // 📝 Description Title
                  Text(
                    "Description:",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                  Text(
                    event.description ?? "No Description",
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
