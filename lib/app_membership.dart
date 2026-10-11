import 'package:flutter/material.dart';

/// Centralized state for Devotee Membership Tier across the entire app.
/// Plans: 'Free', 'Gold', 'Diamond'
class AppMembership {
  static final ValueNotifier<String> currentPlan = ValueNotifier<String>('Free');

  static bool get isFree => currentPlan.value == 'Free';
  static bool get isGold => currentPlan.value == 'Gold' || currentPlan.value == 'Diamond';
  static bool get isDiamond => currentPlan.value == 'Diamond';

  static void setPlan(String plan) {
    if (currentPlan.value != plan) {
      currentPlan.value = plan;
    }
  }

  static void resetToFree() {
    currentPlan.value = 'Free';
  }
}
