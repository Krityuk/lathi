import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/medicine_reminder/repository/new_entry_repository.dart';
import 'package:sizer/sizer.dart';

class IntervalSelection extends ConsumerStatefulWidget {
  const IntervalSelection({super.key});

  @override
  ConsumerState<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends ConsumerState<IntervalSelection> {
  final _intervals = [6, 8, 12, 24];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryRepository newEntryRepository = ref.watch(newEntryRepositoryProvider);
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: kTextColor,
            ),
          ),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text(
              'Select an Interval',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: kPrimaryColor,
              ),
            )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
                  (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: kSecondaryColor,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(() {
                _selected = newVal!;
                newEntryRepository.updateInterval(newVal);
              });
            },
          ),
          Text(
            _selected == 1 ? " hour" : " hours",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: kTextColor,
            ),
          ),
        ],
      ),
    );
  }
}