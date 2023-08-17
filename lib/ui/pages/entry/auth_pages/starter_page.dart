part of pages;

class StarterPage extends StatefulWidget {
  const StarterPage({Key? key}) : super(key: key);

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width,
            height: 406.h,
            decoration: const BoxDecoration(

              image: DecorationImage(
                image:  AssetImage("assets/images/Organe top shape.png",
                 ),
                fit: BoxFit.cover
              )
            ),
          ),
          Transform.translate(
              offset: const Offset(0,-80),
              child: const SplashLogo()),
           SizedBox(
             height: 58.h,
             width: 271.w,
             child: Text(
               "Discover the best foods from over 1,000 restaurants and fast delivery to your doorstep",
               style: Theme.of(context).textTheme.labelMedium,
               textAlign: TextAlign.center,
             ),
           ),
           Padding(
               padding: EdgeInsets.only(
                   right: 34.w, left: 34.w,  bottom: 20.h),
               child: CustomButton(text: "Login", onPress: (){
                 ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.loginPage);
               })),
           OutlinedButton(
             onPressed: (){
               ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.signUpPage);
             },
             style: ElevatedButton.styleFrom(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(28.r)
                 ),
                 side: const BorderSide(
                     color: orangeColor
                 ),
                 minimumSize: Size(307.w, 56.h),
                 padding: const EdgeInsets.all(16)
             ),
             child: const Text("Create an Account", style: TextStyle(color: orangeColor),),
           ),

        ],
      ),
    );
  }
}
