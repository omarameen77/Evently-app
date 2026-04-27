import 'package:event_app/core/models/category_model.dart';
import 'package:event_app/core/models/event.dart';
import 'package:event_app/core/ui/home/tabs/mabs/mab_tab.dart';
import 'package:event_app/core/ui/home/tabs/home/view_model/home_view_model.dart';
import 'package:event_app/core/ui/home/tabs/home/view_model/navigator_view_model.dart';
import 'package:event_app/l10n/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});
  static const String routeName = "event_screen";

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen>
    implements NavigatorViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final HomeViewModel homeViewModel = HomeViewModel();

  Category selectedCategory = Category.categories[0];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    homeViewModel.navigatorViewModel = this;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider.value(
      value: homeViewModel,
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.createEvent)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 🖼 CATEGORY IMAGE (UNCHANGED)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(selectedCategory.imagePath),
            ),

            SizedBox(height: height * 0.02),

            /// 🏷 CATEGORY SELECTOR (UNCHANGED)
            Text("Category", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),

            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Category.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = Category.categories[index];
                  final isSelected = selectedCategory.id == category.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected
                            ? Colors.blue
                            : Theme.of(context).cardColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(category.imagePath, height: 50),
                          const SizedBox(height: 6),
                          Text(category.nameEn),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: height * 0.02),

            /// TITLE
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Event title"),
            ),

            SizedBox(height: height * 0.02),

            /// DESCRIPTION
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: "Event description"),
            ),

            SizedBox(height: height * 0.02),

            /// DATE
            TextButton(
              onPressed: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
                setState(() {});
              },
              child: Text(
                selectedDate == null
                    ? "Choose Date"
                    : DateFormat('dd/MM/yyyy').format(selectedDate!),
              ),
            ),

            /// TIME
            TextButton(
              onPressed: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {});
              },
              child: Text(
                selectedTime == null
                    ? "Choose Time"
                    : selectedTime!.format(context),
              ),
            ),

            OutlinedButton(
              onPressed: () async {
                final result = await Navigator.push<LatLng>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapTab(isPickingMode: true),
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedLocation = result;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedLocation == null
                        ? "Choose Location"
                        : "Location Selected",
                  ),
                  Icon(
                    selectedLocation == null
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.check_circle,
                    color: selectedLocation == null ? null : Colors.green,
                    size: 20,
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

            /// ADD EVENT (SAFE)
            FilledButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  showError("Enter title");
                  return;
                }

                if (selectedLocation == null) {
                  showError("Please select location");
                  return;
                }

                final event = Event(
                  title: titleController.text,
                  description: descriptionController.text,
                  eventDate: selectedDate?.millisecondsSinceEpoch,
                  eventTime: selectedTime?.hour,
                  categoryId: selectedCategory.id,
                  lat: selectedLocation!.latitude,
                  lng: selectedLocation!.longitude,
                );

                homeViewModel.setEventInFirestore(event);
              },
              child: Text(AppLocalizations.of(context)!.addEvent),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void goToHome() {
    Navigator.pop(context);
  }

  @override
  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }
}
