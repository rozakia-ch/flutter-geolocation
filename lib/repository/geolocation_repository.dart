import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';

class GeolocationRepository {
  Future createLogLocation(position) async {
    final String apiURL = 'http://kartolo.karibiya.my.id:2523';
    String? deviceId = await PlatformDeviceId.getDeviceId;
    try {
      var request = await http.post(
        Uri.parse(apiURL + "/create-log-position"),
        body: {
          'device_id': deviceId,
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );
      print(request.body);
    } catch (e) {
      print(e);
      return e;
    }
  }
}
