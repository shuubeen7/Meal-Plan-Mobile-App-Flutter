import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/admin/add_user.dart';
import 'package:meal_plan/features/admin/admin_list_orders.dart';

import '../models/user.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<UserModel> users = [];
  List userKey = [];
  var list = FirebaseDatabase.instance
      .ref("users")
      .orderByChild("value")
      .equalTo("user");
  bool isOn = false;

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Users"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AddUser()));
          },
          child: Icon(Icons.add)),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Text("* Toggle To Ban the User"),
            Text("* Long Press to View Details of User"),
            StreamBuilder<DatabaseEvent>(
              stream: list.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print("List${snapshot.data?.snapshot.value}");
                  Map<dynamic, dynamic> values = snapshot.data?.snapshot.value as Map;
                  userKey.clear();
                  users.clear();
                  values.forEach((key, value) {
                    userKey.add(key);
                    users.add(UserModel.fromJson(value));
                  });

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTapDown:(details){
                          _getTapPosition(details);
                        } ,
                        onLongPress: (){
                         _showContextMenu(context, userKey[index]);
                        },
                        child: SwitchListTile(
                          value: users[index].isBan,
                          onChanged: (bool value) {
                            DatabaseReference ref = FirebaseDatabase.instance
                                .ref("users")
                                .child(userKey[index]);
                            ref.update({"isBan": users[index].isBan ? false : true});
                          },
                          title: Text(users[index].name),
                          subtitle: Text(users[index].email),
                        ),
                      );
                    },
                    itemCount: users.length,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  void _showContextMenu(BuildContext context, String uid) async {
    final RenderObject? overlay =
    Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),

        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
          const PopupMenuItem(
            value: 'orders',
            child: Text('View Orders'),
          ),
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case 'delete':
        FirebaseAuth auth = FirebaseAuth.instance;
        DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");
        await ref.remove();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User Deleted"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        break;
      case 'orders':
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminListOrders(uid: uid)));
        break;
    }
  }


}
