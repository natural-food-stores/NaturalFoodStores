import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/colors_theme.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants.dart';
import '../../widgets/product_list.dart';
import '../../widgets/carousel.dart';
import '../../widgets/search.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Natural Food Stores",
          style: TextStyle(
            color: ThemeColor.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/notification_icon.svg',
                color: ThemeColor.white,
                height: 24,
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.notificationPage);
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ThemeColor.primary, ThemeColor.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
            ),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Obx(
            () => Column(
              children: [
                SizedBox(height: 20),
                // Search Bar with enhanced styling
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
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
                ),
                SizedBox(height: 24),
                // Carousel with enhanced styling
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Carousel(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: homeController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ThemeColor.accent,
                            strokeWidth: 3,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24),
                            // Section Header with enhanced styling
                            _buildSectionHeader(
                              "Exclusive Offer",
                              () {
                                Get.toNamed(AppRoutes.productListPage,
                                    arguments: {
                                      ARG_EXCLUSIVE_OFFER_LIST:
                                          homeController.exclusiveOfferList,
                                      ARG_CATEGORY_NAME: "Exclusive Offer"
                                    });
                              },
                            ),
                            SizedBox(height: 12),
                            ProductList(
                              product: homeController.exclusiveOfferList,
                            ),
                            SizedBox(height: 32),
                            _buildSectionHeader(
                              "Best Selling",
                              () {
                                Get.toNamed(AppRoutes.productListPage,
                                    arguments: {
                                      ARG_BEST_SELLING_LIST:
                                          homeController.bestSellingList,
                                      ARG_CATEGORY_NAME: "Best Selling"
                                    });
                              },
                            ),
                            SizedBox(height: 12),
                            ProductList(
                              product: homeController.bestSellingList,
                            ),
                            SizedBox(height: 32),
                            // Categories Section with enhanced styling
                            Text(
                              "Shop by category",
                              style: TextStyle(
                                color: ThemeColor.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 16),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: homeController.categoryList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.productListPage,
                                        arguments: {
                                          ARG_CATEGORY_ID:
                                              homeController.categoryList[index].id,
                                          ARG_CATEGORY_NAME:
                                              homeController.categoryList[index].name
                                        });
                                  },
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
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CircleAvatar(
                                        radius: 36,
                                        backgroundColor:
                                            AppUtils.getRandomAvatarBgColor(),
                                        child: ClipOval(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${homeController.categoryList[index].imageUrl}",
                                              width: double.infinity,
                                              height: double.infinity,
                                              placeholder: (context, url) => Center(
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    color: ThemeColor.accent,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  Icon(
                                                Icons.error,
                                                color: ThemeColor.red,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                            ),
                            SizedBox(height: 32),
                            _buildSectionHeader(
                              "All Products",
                              () {
                                Get.toNamed(AppRoutes.searchStorePage);
                              },
                            ),
                            SizedBox(height: 12),
                            ProductList(
                              product: homeController.allProductList,
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: ThemeColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColor.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "See All",
              style: TextStyle(
                color: ThemeColor.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
