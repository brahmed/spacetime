import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  /// Sets the app locale. Pass `null` to follow the device locale.
  void setLocale(Locale locale) => emit(locale);
}
