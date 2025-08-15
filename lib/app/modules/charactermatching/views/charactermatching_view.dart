import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/charactermatching_controller.dart';

class CharactermatchingView extends GetView<CharactermatchingController> {
  const CharactermatchingView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    return Scaffold(
      appBar: customAppBar(title: controller.activity ?? 'charactermatching'),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
               Text(
                'charactermatching.animals'.tr,
                style: TextStyle(
                  fontSize: Responsive.sp(context, isTablet ? 20 : 18),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              // Image grid
              Obx(() {
                var q = controller.questions[controller.currentIndex.value];
                final double gridSide = Responsive.hp(isTablet ? 0.5 : 0.48);
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: 4,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 48 : 24,
                    vertical: isTablet ? 24 : 16,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              q["images"]![index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        
                          Obx(() =>  !controller.revealed[index] ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.question_mark,
                                  size: isTablet ? 88 : 72,
                                  color: Colors.black,
                                ),
                              ),
                            ) : const SizedBox()
                          ),
                      ],
                    );
                  },
                );
              }),
              // const SizedBox(height: 20),
              // 2 vertical lists
              Obx(() {
                var q = controller.questions[controller.currentIndex.value];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left column (Chinese)
                    Column(
                      children: List.generate(q["chinese"]!.length, (i) {
                        bool isSelected = controller.selectedLeft.value == i;
                        bool isMatched = controller.revealed[i];
                        Color bg = whiteColor;
                        if (isMatched) bg = Colors.green[200]!;
                        else if (isSelected && controller.selectedRight.value != -1) {
                          var map = q["map"] as Map<int, int>;
                          bg = (map[i] == controller.selectedRight.value)
                              ? Colors.green[200]!
                              : Colors.red[200]!;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ChoiceChip(
                            label: Text(
                              q["chinese"]![i],
                              style: TextStyle(fontSize: Responsive.sp(context, isTablet ? 16 : 14)),
                            ),
                            selected: isSelected,
                            backgroundColor: bg,
                            selectedColor: bg,
                            side: BorderSide.none,
                            onSelected: (val) {
                              controller.selectLeft(i);
                            },
                          ),
                        );
                      }),
                    ),
                    // Right column (English)
                    Column(
                      children: List.generate(q["english"]!.length, (i) {
                        bool isSelected = controller.selectedRight.value == i;
                        bool isMatched = controller.revealed
                            .asMap()
                            .entries
                            .any((entry) => entry.value && (q["map"] as Map<int, int>)[entry.key] == i);
                        Color bg = whiteColor;
                        if (isMatched) bg = Colors.green[200]!;
                        else if (isSelected && controller.selectedLeft.value != -1) {
                          var map = q["map"] as Map<int, int>;
                          bg = (map[controller.selectedLeft.value] == i)
                              ? Colors.green[200]!
                              : Colors.red[200]!;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ChoiceChip(
                            label: Text(
                              q["english"]![i],
                              style: TextStyle(fontSize: Responsive.sp(context, isTablet ? 16 : 14)),
                            ),
                            selected: isSelected,
                            backgroundColor: bg,
                            side: BorderSide.none,
                            selectedColor: bg,
                            onSelected: (val) {
                              controller.selectRight(i);
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 5),
              // Progress bar
              Obx(() => LinearProgressIndicator(
                    value: controller.progress.value,
                    backgroundColor: primaryColor.withValues(alpha: 0.4),
                    color: primaryColor,
                    minHeight: 5,
                  )),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  "correctanswers".tr + ": ${controller.currentIndex.value}/${controller.questions.length}",
                  style: TextStyle(fontSize: Responsive.sp(context, isTablet ? 16 : 14)),
                ),
              ),
              SizedBox(height: 10),
              // Pass button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: controller.passQuestion,
                  child: Text(
                    'pass'.tr,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: Responsive.sp(context, isTablet ? 16 : 14),
                    ),
                  ),
                ),
              ),              
            ],
          ),
        ),
      ),
    );
  }
}
