import 'package:flutter/widgets.dart';

/// Abstract class for navigation service following Clean Architecture.
///
/// This interface allows the presentation layer (BLoCs/ViewModels) to 
/// trigger navigation without depending on [BuildContext] or a specific
/// routing package.
abstract class NavigationService {
  /// The key used to access the [NavigatorState] without a [BuildContext].
  GlobalKey<NavigatorState> get navigatorKey;

  /// Navigates to a named route.
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  });

  /// Replaces the current route with a named route.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  });

  /// Navigates to a named route and removes all previous routes until the [predicate] returns true.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  });

  /// Pops the current route off the navigator.
  void pop<T extends Object?>([T? result]);

  /// Pops routes until the [predicate] returns true.
  void popUntil(bool Function(Route<dynamic>) predicate);

  /// Returns true if the navigator can be popped.
  bool canPop();
}
