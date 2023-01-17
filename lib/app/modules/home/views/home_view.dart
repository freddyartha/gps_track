import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){controller.lihatMap();}, 
            child: const Text("Lihat Map")
      ),
        ),
      )
    );
  }
}
