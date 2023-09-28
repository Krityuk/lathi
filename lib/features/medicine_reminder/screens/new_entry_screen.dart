import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/medicine_reminder/controller/medicine_controller.dart';
import 'package:laathi/features/medicine_reminder/repository/new_entry_repository.dart';
import 'package:sizer/sizer.dart';
import 'package:laathi/features/medicine_reminder/utils/error.dart';
import 'package:laathi/features/medicine_reminder/utils/medicine_model.dart';
import 'package:laathi/features/medicine_reminder/utils/medicine_type.dart';
import 'package:laathi/features/medicine_reminder/widgets/medicine_type_column.dart';
import 'package:laathi/features/medicine_reminder/widgets/panel_title.dart';
import 'interval_selection_screen.dart';
import 'success_screens.dart';
import 'time_select_screen.dart';

class NewEntryPage extends ConsumerStatefulWidget {
  const NewEntryPage({super.key});

  @override
  ConsumerState<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends ConsumerState<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    // initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final NewEntryRepository newEntryRepository = ref.watch(newEntryRepositoryProvider);
    final MedicineController medicineController = ref.watch(medicineControllerProvider);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PanelTitle(
              title: 'Medicine Name',
              isRequired: true,
            ),
            TextFormField(
              maxLength: 12,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kOtherColor),
            ),
            const PanelTitle(
              title: 'Dosage in mg',
              isRequired: false,
            ),
            TextFormField(
              maxLength: 12,
              controller: dosageController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kOtherColor),
            ),
            SizedBox(
              height: 2.h,
            ),
            const PanelTitle(title: 'Medicine Type', isRequired: false),
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: StreamBuilder<MedicineType>(
                  //new entry block
                  stream: newEntryRepository.selectedMedicineType,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Not yet clickable
                        MedicineTypeColumn(
                            medicineType: MedicineType.bottle,
                            name: 'Bottle',
                            iconValue: 'assets/icons/bottle.svg',
                            isSelected: snapshot.data == MedicineType.bottle
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.pill,
                            name: 'Pills',
                            iconValue: 'assets/icons/pills.svg',
                            isSelected: snapshot.data == MedicineType.pill
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.syringe,
                            name: 'Syringe',
                            iconValue: 'assets/icons/syringe.svg',
                            isSelected: snapshot.data == MedicineType.syringe
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.tablet,
                            name: 'Tablets',
                            iconValue: 'assets/icons/tablet.svg',
                            isSelected: snapshot.data == MedicineType.tablet
                                ? true
                                : false),
                      ],
                    );
                  }),
            ),
            const PanelTitle(title: 'Interval Selection', isRequired: true),
            const IntervalSelection(),
            const PanelTitle(title: 'Starting Time', isRequired: true),
            const SelectTime(),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
              ),
              child: SizedBox(
                width: 80.w,
                height: 8.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: kScaffoldColor,
                          ),
                    ),
                  ),
                  onPressed: () {
                    // add medicine
                    // some validations
                    // go to success screen
                    String? medicineName;
                    int? dosage;

                    //medicine name
                    if (nameController.text == "") {
                      newEntryRepository.submitError(EntryError.nameNull);
                      return;
                    } else {
                      medicineName = nameController.text;
                    }
                    dosage = (dosageController.text == "")
                        ? 0
                        : dosage = int.parse(dosageController.text);
                    for (var medicine in medicineController.medicineList$!.value) {
                      if (medicineName == medicine.medicineName) {
                        newEntryRepository
                            .submitError(EntryError.nameDuplicate);
                        return;
                      }
                    }
                    if (newEntryRepository.selectedIntervals!.value == 0) {
                      newEntryRepository.submitError(EntryError.interval);
                      return;
                    }
                    if (newEntryRepository.selectedTimeOfDay$!.value ==
                        'None') {
                      newEntryRepository.submitError(EntryError.startTime);
                      return;
                    }

                    String medicineType = newEntryRepository
                        .selectedMedicineType!.value
                        .toString()
                        .substring(13);

                    int interval = newEntryRepository.selectedIntervals!.value;
                    String startTime =
                        newEntryRepository.selectedTimeOfDay$!.value;

                    List<int> intIDs = makeIDs(
                        24 / newEntryRepository.selectedIntervals!.value);
                    List<String> notificationIDs =
                        intIDs.map((i) => i.toString()).toList();

                    Medicine newEntryMedicine = Medicine(
                        notificationIDs: notificationIDs,
                        medicineName: medicineName,
                        dosage: dosage,
                        medicineType: medicineType,
                        interval: interval,
                        startTime: startTime);

                    //update medicine list via global bloc
                    medicineController.updateMedicineList(newEntryMedicine);

                    //schedule notification

                    //go to success screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuccessScreen()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //
  // void initializeErrorListen() {
  //   _newEntryController.errorState$!.listen((EntryError error) {
  //     switch (error) {
  //       case EntryError.nameNull:
  //         //show snackBar
  //         displayError("Please enter the medicine's name");
  //         break;
  //
  //       case EntryError.nameDuplicate:
  //         displayError("Medicine name already exists");
  //         break;
  //
  //       case EntryError.dosage:
  //         displayError("Please enter the dosage required");
  //         break;
  //
  //       case EntryError.interval:
  //         displayError("Please select the reminder's starting time");
  //         break;
  //
  //       case EntryError.startTime:
  //         displayError('Please select a start time');
  //         break;
  //
  //       default:
  //     }
  //   } as void Function(dynamic value)?);
  // }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        duration: const Duration(milliseconds: 20000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
}
