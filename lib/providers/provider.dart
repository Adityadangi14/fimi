import 'package:fimi/modals/newUserModal.dart';
import 'package:fimi/services/AuthServices/authHelper.dart';
import 'package:fimi/services/DatabaseServices/databaseServices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googlelogInProvider = Provider((ref) => AuthHelper());
final databaseServicesProvider = Provider((ref) => DatabaseServices());
final newUserModalProbvider = Provider((ref) => NewUserModal());
