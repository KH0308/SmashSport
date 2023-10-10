import 'package:flutter/material.dart';
import 'colors.dart' as color;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text("Training", style: TextStyle(fontSize: 30,
                  color: color.AppColor.textBlack, fontWeight: FontWeight.w700),
                ),
                Expanded(child: Container()),
                Icon(Icons.arrow_back_ios, size: 20,
                    color: color.AppColor.homePageIcons),
                const SizedBox(width: 10,),
                Icon(Icons.calendar_today_outlined, size: 20,
                    color: color.AppColor.homePageIcons),
                const SizedBox(width: 15,),
                Icon(Icons.arrow_forward_ios, size: 20,
                    color: color.AppColor.homePageIcons),
              ],
            ),
            const SizedBox(height: 30,),
            Row(
              children: [
                Text("Your Program", style: TextStyle(fontSize: 20,
                    color: color.AppColor.textBlack, fontWeight: FontWeight.w700),
                ),
                Expanded(child: Container()),
                Text("Details", style: TextStyle(fontSize: 20,
                    color: color.AppColor.homePageDetail,),
                ),
                const SizedBox(width: 5,),
                Icon(Icons.arrow_forward, size: 20, color: color.AppColor.homePageIcons)
              ],
            ),
            const SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.AppColor.gradientTurquoise,
                      color.AppColor.gradientBlue
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(80)
                  ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(10, 10),
                    blurRadius: 20,
                    color: color.AppColor.gradientBlue.withOpacity(0.2)
                  )
                ]
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Next Workout", style: TextStyle(fontSize: 16,
                    color: color.AppColor.homePageContainerTextSmall),
                    ),
                    const SizedBox(height: 5,),
                    Text("Legs Toning", style: TextStyle(fontSize: 16,
                        color: color.AppColor.homePageContainerTextSmall),
                    ),
                    const SizedBox(height: 5,),
                    Text("and Gluteal Workout", style: TextStyle(fontSize: 16,
                        color: color.AppColor.homePageContainerTextSmall),
                    ),
                    const SizedBox(height: 25,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer, size: 20, color: color.AppColor.homePageContainerTextSmall,),
                            const SizedBox(width: 10,),
                            Text("60 min", style: TextStyle(fontSize: 14,
                                color: color.AppColor.homePageContainerTextSmall),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: color.AppColor.gradientTurquoise,
                                blurRadius: 10,
                                offset: const Offset(4, 8),
                              )
                            ]
                          ),
                          child: const Icon(
                            Icons.play_circle_fill, color: Colors.white, size: 60,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
