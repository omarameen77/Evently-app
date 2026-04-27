import 'package:event_app/core/models/category_model.dart';
import 'package:event_app/core/models/event.dart';
import 'package:event_app/core/providers/app_configprovider.dart';
import 'package:event_app/core/theme/app_color.dart';
import 'package:event_app/data/firebase/event_firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MapTab extends StatefulWidget {
  final bool isPickingMode;

  const MapTab({super.key, this.isPickingMode = false});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController? mapController;

  String? _mapStyle;

  List<Event> events = [];
  List<Event> filteredEvents = [];

  bool isLoading = true;

  PageController pageController = PageController(viewportFraction: 0.80);

  int currentIndex = 0;

  LatLng? selectedLocation;

  final TextEditingController searchController = TextEditingController();

  final LatLng userLocation = const LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    _loadStyle();
    _listenEvents();
  }

  Future<void> _loadStyle() async {
    _mapStyle = await rootBundle.loadString("assets/map_style.json");
  }

  void _listenEvents() {
    EventFirebaseDatabase.getCollectionOfEvent().snapshots().listen((snapshot) {
      events = snapshot.docs.map((e) => e.data()).toList();

      events = events.where((e) => e.lat != null && e.lng != null).toList();

      filteredEvents = events;

      setState(() => isLoading = false);
    });
  }

  void _search(String query) {
    setState(() {
      filteredEvents = events.where((e) {
        return (e.title ?? "").toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _goToEvent(Event event) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(event.lat!, event.lng!), 16),
    );
  }

  Category getCategory(int id) {
    return Category.categories.firstWhere(
      (c) => c.id == id,
      orElse: () => Category.categories[0],
    );
  }

  void _confirmLocation() {
    if (!widget.isPickingMode) return;
    if (selectedLocation == null) return;

    Navigator.pop(context, selectedLocation);
  }

  String _formatTime(int? hour) {
    if (hour == null) return "--:--";
    final time = TimeOfDay(hour: hour, minute: 0);
    return time.format(context);
  }

  String _formatDate(int? millis) {
    if (millis == null) return "No date";

    final date = DateTime.fromMillisecondsSinceEpoch(millis);

    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    var appConfig = Provider.of<AppConfigprovider>(context);

    return Scaffold(
      body: Stack(
        children: [
          /// 🌍 MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation,
              zoom: 10,
            ),
            onMapCreated: (controller) {
              mapController = controller;
              controller.setMapStyle(appConfig.isDark() ? _mapStyle : null);
            },

            onTap: widget.isPickingMode
                ? (pos) {
                    setState(() {
                      selectedLocation = pos;
                    });
                  }
                : null,

            markers: {
              ...filteredEvents.map((event) {
                return Marker(
                  markerId: MarkerId(event.id ?? ""),
                  position: LatLng(event.lat!, event.lng!),
                  onTap: () {
                    int index = filteredEvents.indexOf(event);
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              }),

              if (selectedLocation != null)
                Marker(
                  markerId: const MarkerId("selected"),
                  position: selectedLocation!,
                ),
            },
          ),

          /// 🔎 SEARCH (UNCHANGED)
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(blurRadius: 8, color: Colors.black12),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: _search,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search events...",

                  hintStyle: TextStyle(
                    color: appConfig.isDark()
                        ? AppColors.darkPurple
                        : AppColors.darkPurple,
                  ),
                  icon: Icon(Icons.search, color: Colors.black),

                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 130,
              child: PageView.builder(
                controller: pageController,
                itemCount: filteredEvents.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                  _goToEvent(filteredEvents[index]);
                },
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  final category = getCategory(event.categoryId ?? 0);

                  final active = index == currentIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: active ? 6 : 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: appConfig.isDark()
                            ? [
                                //  AppColors.darkPurple,
                                AppColors.navyBlue,
                                AppColors.navyBlue,

                                AppColors.lightBlue,
                              ]
                            : [AppColors.purple, AppColors.white],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).cardColor,
                      boxShadow: const [
                        BoxShadow(blurRadius: 6, color: Colors.black12),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// 🖼 IMAGE
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Image.asset(
                            category.imagePath,
                            width: 130,
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),

                        /// 📄 INFO
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// TITLE
                                Text(
                                  event.title ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                /// LOCATION + TIME
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 4),

                                    Expanded(
                                      child: Text(
                                        event.lat != null && event.lng != null
                                            ? "Location set"
                                            : "No location",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 14,
                                      color: Colors.green,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      _formatDate(event.eventDate),
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 4),

                                    Text(
                                      _formatTime(event.eventTime),
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          /// ✔ CONFIRM LOCATION
          if (widget.isPickingMode)
            Positioned(
              bottom: 140,
              right: 20,
              child: FloatingActionButton(
                onPressed: _confirmLocation,
                child: const Icon(Icons.check),
              ),
            ),

          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
