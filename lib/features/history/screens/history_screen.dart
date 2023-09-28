import 'package:flutter/material.dart';
import 'package:laathi/utils/constants.dart';

class LogsScreen extends StatelessWidget {
  static const String routeName = '/logs';
  const LogsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Log History",style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.purple,
          actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.filter_alt_sharp, color: Colors.white,))],
        ),
        body: ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location Requested", style: kFontStyle,),
                              Text('From: Al Kahaf')
                            ],
                          ),
                          Column(
                            children: [
                              Text('July 10, 2023, 16:58'),
                            ],
                          ),
                        ],
                      ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("OTP Requested", style: kFontStyle,),
                          Text('From: Jigyashu')
                        ],
                      ),
                      Column(
                        children: [
                          Text('July 10, 2023, 16:58'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            itemCount: 3),
      ),
    );
  }
}
