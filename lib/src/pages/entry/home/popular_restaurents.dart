part of pages;

class PupularResturent extends StatelessWidget {
  const PupularResturent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ItemModel.popular.length,
        itemBuilder: (context, index) {
          ItemModel data = ItemModel.popular[index];
          return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //margin: EdgeInsetsDirectional.only(start: 0, end: 0),
              children: [
              Image.asset(data.imagePath,
              fit: BoxFit.fitWidth,
              width: double.infinity,),
          SizedBox(
          height: 11.h,
          ),
          Column(
                mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(data.name,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: primaryFontColor,
          fontWeight: FontWeight.bold),),
          Row(
          children: [
          ItemRating(rating: data.rating,),
          SizedBox(width: 3.h,),
          Text('(${data.ratingCount} rating)',
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: secondaryFontColor,
          fontWeight: FontWeight.bold),),
          ],
          )
          ]
          ,
          )
          ,

          ]
          ,
          );
        });
  }
}
