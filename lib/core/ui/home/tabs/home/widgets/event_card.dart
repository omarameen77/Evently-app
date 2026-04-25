import 'package:event_app/core/models/category_model.dart';
import 'package:event_app/core/models/event.dart';
import 'package:event_app/core/ui/home/tabs/home/event_details/event_details.dart';
import 'package:event_app/core/utils/extintions.dart';
import 'package:event_app/data/firebase/event_firebase_database.dart';
import 'package:event_app/data/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    //  تحقق من وجود categories
    if (Category.categories.isEmpty) {
      return const SizedBox.shrink();
    }
    // ابحث عن الـ category أو استخدم default
    final category = Category.categories.firstWhere(
      (e) => e.id == event.categoryId,
      orElse: () => Category.categories.first,
    );
    var userId = FirebaseAuthService.getUserData()?.uid ?? "";
    return AspectRatio(
      aspectRatio: 360 / 200,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            EventDetails.routeName,
            arguments: {"event": event, "category": category},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            image: DecorationImage(
              image: AssetImage(category.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        Text(
                          (event.eventDate ?? 0).formatDate("dd\nMMM"),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title ?? "",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          EventFirebaseDatabase.updateFavoriteList(
                            event,
                            userId,
                          );
                        },
                        child: Icon(
                          (event.favoriteList ?? []).contains(userId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
