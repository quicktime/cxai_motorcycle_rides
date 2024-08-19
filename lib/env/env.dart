import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static const String openAiApiKey = _Env.openAiApiKey;
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY') // the .env variable.
  static const String googleMapsApiKey = _Env.googleMapsApiKey;
}
