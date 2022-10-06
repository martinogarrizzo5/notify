import "package:map_launcher/map_launcher.dart";
import 'package:url_launcher/url_launcher.dart';

class ExternalMapUtils {
  ////////////// map_launcher /////////////////

  static Future<void> openMap(double latitude, double longitude) async {
    bool? isMapAvailable = await MapLauncher.isMapAvailable(MapType.google);

    if (isMapAvailable == true) {
      MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(latitude, longitude),
        // not working on gmap versions less than 11.12
        title: "Selected Position",
        zoom: 15,
      );
    }
  }

  // start location is by default the user's current location
  static Future<void> showMapDirections(
      double latitude, double longitude) async {
    bool? isMapAvailable = await MapLauncher.isMapAvailable(MapType.google);

    if (isMapAvailable == true) {
      MapLauncher.showDirections(
        mapType: MapType.google,
        destination: Coords(latitude, longitude),
        // gmap waypoints supported if origin parameter is set
        waypoints: [
          Coords(45.65496954, 12.20451457),
          Coords(45.6296728, 12.3763104),
        ],
        origin: Coords(45.6296728, 12.1763104),
        originTitle: "My Location",
      );
    }
  }

  /////////// url_launcher /////////////////////////////

  static void launchMapsUrl(double lat, double lon) async {
    final url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchMapsDirectionUrl(double lat, double lon) async {
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
