import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/medicine_reminder/repository/new_entry_repository.dart';
import 'package:sizer/sizer.dart';
import 'package:laathi/features/medicine_reminder/utils/medicine_type.dart';

class MedicineTypeColumn extends ConsumerWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected});

  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NewEntryRepository newEntryBloc =
        ref.watch(newEntryRepositoryProvider);
    return GestureDetector(
      onTap: () {
        // select medicine type
        // lets create a new block for selecting and adding an entry

        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? kOtherColor : Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                  colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : kOtherColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(100.h),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: isSelected ? Colors.white : kOtherColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
