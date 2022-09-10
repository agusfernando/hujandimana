import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hujandimana/app/data/data.dart';
import 'package:hujandimana/app/models/rara_response.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  Rx<LatLng> originLocation = LatLng(-6.3077878, 106.6981741).obs;
  // Rx<LatLng> destinationLocation = LatLng(-6.3032166, 106.683861).obs;
  BetterPlayerController betterPlayerController =
      BetterPlayerController(const BetterPlayerConfiguration());
  Rx<RaraResponse> dataRara = RaraResponse(data: []).obs;
  RxBool playbutton = true.obs;
  RxBool isloading = true.obs;
  Set<Marker> markers = {};
  LocationData? currentLocation;

  @override
  void onInit() async {
    dataRara.value = await getRaraResponse();
    print('response_ok : ${dataRara.value.data}');
    await getLocation();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then(
      (value) {
        originLocation.value = LatLng(value.latitude!, value.longitude!);
      },
    );

    isloading.value = false;
  }

  Future<RaraResponse> getRaraResponse() async {
    try {
      var responseResult = await http
          .get(
            Uri.parse(
              'https://api.ipat.my.id/cctvs',
            ),
          )
          .timeout(
            const Duration(
              seconds: 10,
            ),
          );

      if (responseResult.statusCode == 200) {
        return RaraResponse.fromMap(data);
      } else
        throw Exception('Failed to load RaraResponse');
    } on Exception catch (e) {
      return RaraResponse(data: []);
    }
  }

  void getMarker() {
    markers = dataRara.value.data
        .map(
          (data) => Marker(
            markerId: MarkerId(data.namaLokasi),
            position: LatLng(
              double.parse(data.latLokasi),
              double.parse(data.lonLokasi),
            ),
          ),
        )
        .toSet();
  }

  void initializeConfigBetterPlayer(BuildContext context, {String url = ""}) {
    BetterPlayerControlsConfiguration controlsConfiguration =
        const BetterPlayerControlsConfiguration(
      controlBarColor: Colors.black26,
      iconsColor: Colors.white,
      playIcon: Icons.play_arrow_outlined,
      progressBarPlayedColor: Color(0xffFF8181),
      progressBarHandleColor: Color(0xffFF8181),
      skipBackIcon: Icons.replay_10_outlined,
      skipForwardIcon: Icons.forward_10_outlined,
      backwardSkipTimeInMilliseconds: 10000,
      forwardSkipTimeInMilliseconds: 10000,
      enableSkips: true,
      enableFullscreen: true,
      enablePip: true,
      enablePlayPause: true,
      enableMute: true,
      enableAudioTracks: false,
      enableProgressText: true,
      enableSubtitles: false,
      enableQualities: true,
      showControlsOnInitialize: true,
      enablePlaybackSpeed: true,
      controlBarHeight: 40,
      loadingColor: Colors.red,
      overflowModalColor: Colors.black54,
      overflowModalTextColor: Colors.white,
      overflowMenuIconsColor: Colors.white,
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoDispose: true,
      controlsConfiguration: controlsConfiguration,
      aspectRatio: 16 / 9,
      fit: BoxFit.fill,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      useAsmsSubtitles: true,
    );
    betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
    // betterPlayerController.setupDataSource(dataSource);

    betterPlayerController.addEventsListener(
      (event) async {
        if (event.betterPlayerEventType == BetterPlayerEventType.play) {}
      },
    );
  }
}
