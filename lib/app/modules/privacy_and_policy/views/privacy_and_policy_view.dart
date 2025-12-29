import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/modules/privacy_and_policy/controllers/privacy_and_policy_controller.dart';

class PrivacyPolicyPage extends GetView<PrivacyController> {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF8DC63F);
    const Color lightGreenColor = Color(0xFFEAF5DC);
    const Color lightGreyColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section - Mengikuti gaya banner Dashboard
            _buildHeroSection(greenColor, lightGreenColor),

            const SizedBox(height: 24),

            _buildSectionTitle("Kebijakan Privasi"),
            const SizedBox(height: 16),

            // Content List
            _buildContentList(greenColor, lightGreenColor),

            const SizedBox(height: 32),

            // Footer Action
            _buildFooterAction(greenColor),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Privasi & Kebijakan',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => controller.shareAsPdf(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7AC943), width: 2),
              ),
              child: Obx(
                () => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF7AC943),
                        ),
                      )
                    : const Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: Color(0xFF7AC943),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(Color greenColor, Color lightGreenColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightGreenColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.security_rounded, color: greenColor, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data Anda Aman",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Kami menjaga privasi Anda dengan standar keamanan tinggi.",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContentList(Color greenColor, Color lightGreenColor) {
    return GetX<PrivacyController>(
      builder: (c) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: c.sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final s = c.sections[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: lightGreenColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: greenColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    s.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        s.body,
                        style: const TextStyle(
                          color: Colors.black87,
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFooterAction(Color greenColor) {
    return Column(
      children: [
        Obx(
          () => Text(
            'Terakhir diperbarui: ${controller.lastUpdated.value}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
        // Container(
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(12),
        //     border: Border.all(color: Colors.grey.shade200),
        //   ),
        //   padding: const EdgeInsets.all(16),
        //   child: Column(
        //     children: [
        //       const Text(
        //         "Apakah Anda menyetujui kebijakan ini?",
        //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        //       ),
        //       const SizedBox(height: 16),
        //       Row(
        //         children: [
        //           Expanded(
        //             child: ElevatedButton(
        //               onPressed: () => Get.back(),
        //               style: ElevatedButton.styleFrom(
        //                 backgroundColor: Colors.white,
        //                 foregroundColor: Colors.grey,
        //                 elevation: 0,
        //                 side: BorderSide(color: Colors.grey.shade300),
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(50),
        //                 ),
        //                 padding: const EdgeInsets.symmetric(vertical: 12),
        //               ),
        //               child: const Text("Tutup"),
        //             ),
        //           ),
        //           const SizedBox(width: 12),
        //           Expanded(
        //             child: ElevatedButton(
        //               onPressed: () {
        //                 Get.snackbar(
        //                   'Sukses',
        //                   'Kebijakan telah disetujui',
        //                   backgroundColor: greenColor,
        //                   colorText: Colors.white,
        //                 );
        //               },
        //               style: ElevatedButton.styleFrom(
        //                 backgroundColor: greenColor,
        //                 foregroundColor: Colors.white,
        //                 elevation: 0,
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(50),
        //                 ),
        //                 padding: const EdgeInsets.symmetric(vertical: 12),
        //               ),
        //               child: const Text("Setuju"),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
