import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/colors_theme.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: Obx(
          () => profileController.isLoading.value
              ? _buildLoadingShimmer()
              : CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    // Profile Header
                    SliverToBoxAdapter(
                      child: _buildProfileHeader(),
                    ),
                    // Main Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Orders Section
                            _buildSectionCard(
                              icon: 'assets/images/orders_icon.svg',
                              title: "Orders",
                              onTap: () => Get.toNamed(AppRoutes.orderListPage),
                            ),
                            SizedBox(height: 12),
                            // My Details Section
                            _buildSectionCard(
                              icon: 'assets/images/my_details_icon.svg',
                              title: "My Details",
                              onTap: () => Get.toNamed(
                                AppRoutes.editProfilePage,
                                arguments: {
                                  ARG_PROFILE_DETAIL:
                                      profileController.userProfileResponse,
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            // Delivery Address Section
                            _buildSectionCard(
                              icon: 'assets/images/address_icon.svg',
                              title: "Delivery Address",
                              onTap: () => Get.toNamed(
                                AppRoutes.deliveryAddressPage,
                                arguments: {
                                  ARG_PROFILE_DETAIL:
                                      profileController.userProfileResponse,
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            // FAQ Section
                            _buildSectionCard(
                              icon: 'assets/images/help_icon.svg',
                              title: "FAQ's",
                              onTap: () => Get.toNamed(AppRoutes.faqsPage),
                            ),
                            SizedBox(height: 12),
                            // Contact Us Section
                            _buildSectionCard(
                              icon: 'assets/images/about_icon.svg',
                              title: "Contact Us",
                              onTap: () => Get.toNamed(AppRoutes.contactUsPage),
                            ),
                            SizedBox(height: 24),
                            // Logout Button
                            _buildLogoutButton(),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Center(
      child: CircularProgressIndicator(
        color: ThemeColor.accent,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
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
            child: CircleAvatar(
              backgroundColor: AppUtils.getRandomAvatarBgColor(),
              radius: 40,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: AppUtils.loginUserDetail().result?.profilePic ?? "",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
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
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: ThemeColor.red,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppUtils.loginUserDetail().result?.firstname ?? "--",
                  style: TextStyle(
                    color: ThemeColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppUtils.loginUserDetail().result?.mobileNumber ?? "--",
                  style: TextStyle(
                    color: ThemeColor.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 24,
                width: 24,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: ThemeColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.grey_200,
          foregroundColor: ThemeColor.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text("Logout"),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Logout",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: ThemeColor.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AppUtils.logout();
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: ThemeColor.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
