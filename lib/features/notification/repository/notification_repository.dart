import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/repository/app_repository.dart';

final notificationRepositoryProvider = Provider(
    (ref) => NotificationRepository(ref.watch(appRepositoryProvider)));

class NotificationRepository {
  final AppRepository databaseRepository;
  NotificationRepository(this.databaseRepository);
  Future addNotification(
      String receiverId, String receiverName, String type) async {
    await databaseRepository.userCollection
        .doc(receiverId)
        .collection('notifications')
        .add({
      'sender': databaseRepository.currentUser!.uid,
      'name': receiverName,
      'type': type,
      'time': DateTime.now()
    });
    void goToScreen(String senderId, String type) {
      List<String> typeList = type.split(" ");
      switch(typeList[0]){
        case 'request':
      }
    }
  }
}
