import 'package:flutter/material.dart';
import 'package:flutter_firebase_dersleri/screens/Hatirlatici/database/repository.dart';
import 'package:flutter_firebase_dersleri/screens/Hatirlatici/models/pill.dart';
import 'package:flutter_firebase_dersleri/screens/Hatirlatici/notifications/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class MedicineCard extends StatelessWidget {
  final Pill medicine;
  final Function setData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  MedicineCard(
      this.medicine, this.setData, this.flutterLocalNotificationsPlugin);

  @override
  Widget build(BuildContext context) {
    //check if the medicine time is lower than actual
    final bool isEnd = DateTime.now().millisecondsSinceEpoch > medicine.time;

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.symmetric(vertical: 7.0),
      color: Colors.white,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onLongPress: () => _showDeleteDialog(
            context, medicine.name, medicine.id, medicine.notifyId),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        title: Text(
          medicine.name,
          style: Theme.of(context).textTheme.headline1.copyWith(
              color: Colors.black,
              fontSize: 20.0,
              decoration: isEnd ? TextDecoration.lineThrough : null),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${medicine.amount} ",
          style: Theme.of(context).textTheme.headline5.copyWith(
              color: Colors.grey[600],
              fontSize: 15.0,
              decoration: isEnd ? TextDecoration.lineThrough : null),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              DateFormat("HH:mm")
                  .format(DateTime.fromMillisecondsSinceEpoch(medicine.time)),
              style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  decoration: isEnd ? TextDecoration.lineThrough : null),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------| SHOW THE DELETE DIALOG ON THE SCREEN |-----------------------

  void _showDeleteDialog(
      BuildContext context, String medicineName, int medicineId, int notifyId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Sil ?"),
              content: Text(
                  "${medicineName.toUpperCase()} isimli hatırlatmayı silmek istediğine emin misin?"),
              contentTextStyle:
                  TextStyle(fontSize: 17.0, color: Colors.grey[800]),
              actions: [
                FlatButton(
                  splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Text("Delete",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onPressed: () async {
                    await Repository().deleteData('Pills', medicineId);
                    await Notifications().removeNotify(
                        notifyId, flutterLocalNotificationsPlugin);
                    setData();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
  //============================================================================================

}
