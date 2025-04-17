import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/colors_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/category_item_card.dart';
import '../../widgets/search.dart';
import 'explore_controller.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExploreController exploreController = Get.find<ExploreController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Find Products",
          style: TextStyle(
            color: ThemeColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: ThemeColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: exploreController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: ThemeColor.accent,
                      strokeWidth: 3,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Search(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Categories",
                        style: TextStyle(
                          color: ThemeColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      GridView.builder(
                        itemCount: exploreController.categoryList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.productListPage,
                                  arguments: {
                                    ARG_CATEGORY_ID:
                                        exploreController.categoryList[index].id,
                                    ARG_CATEGORY_NAME:
                                        exploreController.categoryList[index].name
                                  });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CategoryItemCard(
                                category: exploreController.categoryList[index],
                                color: exploreController.gridColors[
                                    index % exploreController.gridColors.length],
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                      ),
                    ],
                  ),
          ),
        )),
      ),
    );
  }
}
