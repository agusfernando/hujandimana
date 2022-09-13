import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hujandimana/app/data/widgets/lottie_animation.dart';
import 'package:hujandimana/app/models/rara_response.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => controller.isloading.isTrue
                  ? Container(
                      height: Get.height,
                      child: LottieAnimation(),
                    )
                  : Column(
                      children: [
                        // Center(
                        //   child:
                        //   IconButton(
                        //       onPressed: () {
                        //         Get.bottomSheet(BottomSheetReport(
                        //           data: Rara(
                        //               idLokasi: 1,
                        //               kota: 'kota',
                        //               namaLokasi: 'namaLokasi',
                        //               latLokasi: 'latLokasi',
                        //               lonLokasi: 'lonLokasi',
                        //               m3U8:
                        //                   'http://45.118.114.26/camera/Buahbatu.m3u8',
                        //               publishedAt: '',
                        //               createdAt: '',
                        //               updatedAt: '',
                        //               weatherStatus: ''),
                        //         ));
                        //       },
                        //       icon: Icon(Icons.abc)),
                        // ),
                        Container(
                          width: Get.width,
                          height: Get.height,
                          child: GoogleMap(
                            myLocationButtonEnabled: true,
                            // myLocationEnabled: true,
                            zoomGesturesEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: controller.originLocation.value,
                              zoom: 11,
                            ),

                            markers: controller.dataRara.value.data
                                .map(
                                  (data) => Marker(
                                    markerId: MarkerId(data.namaLokasi),
                                    position: LatLng(
                                      double.parse(data.latLokasi),
                                      double.parse(data.lonLokasi),
                                    ),
                                    onTap: () {
                                      print('object');

                                      Get.bottomSheet(BottomSheetReport(
                                        data: data,
                                      ));
                                    },
                                  ),
                                )
                                .toSet(),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetReport extends StatelessWidget {
  final Rara data;
  HomeController homeController = Get.find<HomeController>();

  BottomSheetReport({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeController.initializeConfigBetterPlayer(context, url: data.m3U8);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(150, 50),
              topRight: Radius.elliptical(150, 50))),
      height: Get.height * .9,
      padding: EdgeInsets.only(top: 15, left: 12, right: 12, bottom: 15),
      child: Column(
        children: [
          Container(
            width: Get.width * .2,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            width: Get.width,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                child: BetterPlayer(
                  controller: homeController.betterPlayerController,
                ),
              ),

              // Image.network(
              //   'https://cctv.ipat.my.id/download/${data.idLokasi}.jpg',
              //   fit: BoxFit.cover,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) {
              //       return Stack(
              //         fit: StackFit.expand,
              //         children: [
              //           child,
              //           IconButton(
              //               color: Colors.amber,
              //               iconSize: 50,
              //               onPressed: () {
              //                 print('play');
              //               },
              //               icon: Icon(Icons.play_circle_outline))
              //         ],
              //       );
              //     } else {
              //       return Center(child: CircularProgressIndicator());
              //     }
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return Column(
              //       children: [
              //         Image.asset('assets/images/imagebroken.png',
              //             width: 200, height: 150, fit: BoxFit.contain),
              //         Text('can not access the cctv')
              //       ],
              //     );
              //   },
              // ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Weather Today',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_city),
                        SizedBox(width: 6),
                        Text(data.namaLokasi)
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 6),
                        Text(data.kota)
                      ],
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/sun.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            ],
          )
        ],
      ),
    );
  }
}
