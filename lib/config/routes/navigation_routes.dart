// navigation_extensions.dart
import 'package:flutter/material.dart';

extension NavigationExtensions on BuildContext {
  /// Push a new page onto the stack.
  void push(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Replace the current page with a new page.
  void navigateReplace(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pop the current page from the stack.
  void pop() {
    Navigator.pop(this);
  }

  /// Push a named route onto the stack.
  void navigateToNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(
      this,
      routeName,
      arguments: arguments,
    );
  }

  /// Replace the current page with a named route.
  void navigateReplaceNamed(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(
      this,
      routeName,
      arguments: arguments,
    );
  }

  /// Push a new page and remove all the previous routes until [predicate] returns true.
  void pushAndRemoveUntil(
      Widget page, bool Function(Route<dynamic>) predicate) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  /// Push a named route and remove all the previous routes until [predicate] returns true.
  void pushNamedAndRemoveUntil(
      String routeName, bool Function(Route<dynamic>) predicate,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Pop routes until the [predicate] returns true.
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(this, predicate);
  }

  /// Remove all routes until the first route.
  void popUntilFirst() {
    Navigator.popUntil(this, (route) => route.isFirst);
  }

  /// Remove all routes and push a new page.
  void pushAndRemoveAll(Widget page) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (_) => page),
      (Route<dynamic> route) => false,
    );
  }

  /// Remove all routes and push a named route.
  void pushNamedAndRemoveAll(String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }
}
