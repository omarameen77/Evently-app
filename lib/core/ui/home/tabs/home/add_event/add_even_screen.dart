import 'package:event_app/core/ui/home/tabs/home/add_event/widget/tapcontroller.dart';
import 'package:event_app/core/ui/home/tabs/home/view_model/home_view_model.dart';
import 'package:event_app/core/ui/home/tabs/home/view_model/navigator_view_model.dart';
import 'package:event_app/core/ui/home/tabs/mabs/mab_tab.dart';
import 'package:event_app/l10n/translations/app_localizations.dart';
import 'package:flutter/material.dart';
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
  late HomeViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
    viewModel.navigatorViewModel = this;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.createEvent,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, vm, _) {
            return Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(vm.selectedCategory.imagePath),
                  ),
                  SizedBox(height: height * 0.01),

                  /// Category Tabs
                  Consumer<HomeViewModel>(
                    builder: ( context,vm, _) {
                       return Tapcontroller(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeSelectedCategory(
                          vm.categories.indexOf(category),
                        
                        );
                      },
                    ); },
                    
                  ),

                  SizedBox(height: height * 0.02),

                  /// Title
                  Text(AppLocalizations.of(context)!.title),
                  SizedBox(height: height * 0.01),
                  TextFormField(
                    controller: vm.titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  /// Description
                  Text(AppLocalizations.of(context)!.description),
                  SizedBox(height: height * 0.01),
                  TextFormField(
                    controller: vm.descriptionController,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  /// Date Picker
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.eventDate),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) vm.setSelectedDate(date);
                        },
                        child: Text(
                          vm.selectedDate == null
                              ? AppLocalizations.of(context)!.chooseDate
                              : DateFormat(
                                  'dd/MM/yyyy',
                                ).format(vm.selectedDate!),
                        ),
                      ),
                    ],
                  ),

                  /// Time Picker
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.eventTime),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) vm.setSelectedTime(time);
                        },
                        child: Text(
                          vm.selectedTime == null
                              ? AppLocalizations.of(context)!.chooseTime
                              : vm.selectedTime!.format(context),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.02),

                  /// Location
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MapTab.routeName);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.location_on),
                        SizedBox(width: 10),
                        Text("Choose Event Location"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  /// Submit Button
                  FilledButton(
                    onPressed: vm.isLoading ? null : vm.addEvent,
                    child: vm.isLoading
                        ? const CircularProgressIndicator()
                        : Text(AppLocalizations.of(context)!.addEvent),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Navigator callbacks
  @override
  void goToHome() {
    Navigator.pop(context);
  }

  @override
  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
