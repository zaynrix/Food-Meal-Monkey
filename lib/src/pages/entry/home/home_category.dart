part of pages;

class HomeCategry extends StatelessWidget {
  const HomeCategry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: CategoryModel.lits.length,
        itemBuilder: (context, index) {
          CategoryModel data = CategoryModel.lits[index];
          return Container(
            margin: EdgeInsetsDirectional.only(start: 18),
            width: 88.w,
            height: 113.h,
            child: Column(
                children: [
                  Container(
                      height: 88.h,
                      width: 88.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(data.imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  Text(
                      data.label,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                          color: primaryFontColor
                      )
                  ),


                ]),
          );
        });
  }
}
