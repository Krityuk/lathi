import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/widgets/feature_widget.dart';
import 'package:laathi/features/companion/controller/companion_controller.dart';
import 'package:laathi/features/companion/screens/add_companion_screen.dart';

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: ref.read(companionControllerProvider).providersList,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: snapshot.data!.docs.map((companion) {
                          return Column(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  companion['name'] +
                                      " : " +
                                      companion['country_code'] +
                                      " " +
                                      companion['phone'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            const Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FeatureButton(
                  name: "Add Companion",
                  icon: Icons.add,
                  onPressed: (BuildContext context, WidgetRef ref) {
                    Navigator.pushNamed(context, AddCompanionScreen.routeName);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
