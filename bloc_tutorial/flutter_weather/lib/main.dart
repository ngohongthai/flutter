import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/weather_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_repository/weather_repository.dart';

/*
 * Following the bloc architecture guidelines, our application will consist of several layers.
 * 
 * Data: retrieve raw weather data from the API
 * Repository: abstract the data layer and expose domain models for the application to consume
 * Business Logic: manage the state of each feature (unit information, city details, themes, etc.)
 * Presentation: display weather information and collect input from users (settings page, search page etc.)
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = WeatherBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory());
  runApp(WeatherApp(weatherRepository: WeatherRepository()));
}
