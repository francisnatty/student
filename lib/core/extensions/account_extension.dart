import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';

extension AccountContext on BuildContext {
  AuthProvider get account => Provider.of<AuthProvider>(this, listen: false);
}
