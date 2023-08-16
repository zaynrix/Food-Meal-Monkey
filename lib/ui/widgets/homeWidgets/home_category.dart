import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/styles.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('location_food_types')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            String name = doc['name'];
            String imagePath = doc['imagePath'];
            return Container(
              margin: const EdgeInsetsDirectional.only(start: 18),
              width: 88,
              // height: 113,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                        placeholder: (context, url) =>
                            Center(child: Image.asset(ImageAssets.app_icon)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  FittedBox(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: primaryFontColor,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
