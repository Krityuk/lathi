import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/medicine_reminder/utils/medicine_model.dart';
import 'package:laathi/features/medicine_reminder/repository/medicine_repository.dart';
import 'package:rxdart/rxdart.dart';

// Medicine Controller Provider
final medicineControllerProvider = Provider((ref) => MedicineController(
    medicineRepository: ref.watch(medicineRepositoryProvider)));


//Medicince Controller for Repository
class MedicineController {
  final MedicineRepository medicineRepository;
  MedicineController({required this.medicineRepository});

  BehaviorSubject<List<Medicine>>? get medicineList$ =>
      medicineRepository.medicineList$;

  Future removeMedicine(Medicine m) async {
    await medicineRepository.removeMedicine(m);
  }

  Future updateMedicineList(Medicine m) async {
    await medicineRepository.updateMedicineList(m);
  }

  Future makeMedicineList() async {
    await medicineRepository.makeMedicineList();
  }

  void dispose() {
    medicineRepository.dispose();
  }
}
