import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/admin/add_user.dart';
import 'package:meal_plan/features/admin/admin_list_products.dart';

import '../models/user.dart';
import 'add_vendor.dart';

class ListVendors extends StatefulWidget {
  const ListVendors({Key? key}) : super(key: key);

  @override
  State<ListVendors> createState() => _ListVendorsState();
}

class _ListVendorsState extends State<ListVendors> {
  List<UserModel> vendors = [];
  List vendorKey = [];
  var list = FirebaseDatabase.instance
      .ref("users")
      .orderByChild("value")
      .equalTo("vendor");
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
        title: Text("List Service Providers"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AddVendor()));
          },
          child: Icon(Icons.add)),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Text("* Toggle To Ban the Service Provider"),
            Text("* Long Press to View Details of Service Provider"),
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
                  vendorKey.clear();
                  vendors.clear();
                  values.forEach((key, value) {
                    vendorKey.add(key);
                    vendors.add(UserModel.fromJson(value));
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
                          _showContextMenu(context, vendorKey[index]);
                        },
                        child: SwitchListTile(
                          value: vendors[index].isBan,
                          onChanged: (bool value) {
                            DatabaseReference ref = FirebaseDatabase.instance
                                .ref("users")
                                .child(vendorKey[index]);
                            ref.update({"isBan": vendors[index].isBan ? false : true});
                          },
                          title: Text(vendors[index].name),
                          subtitle: Text(vendors[index].email),
                        ),
                      );
                    },
                    itemCount: vendors.length,
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
            value: 'products',
            child: Text('View Meals'),
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

      case 'products':
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminListProducts(uid: uid)));
      
        break;
    }
  }

}
