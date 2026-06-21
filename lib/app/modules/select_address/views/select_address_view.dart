import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/select_address_controller.dart';

class SelectAddressView extends GetView<SelectAddressController> {
  const SelectAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
        title: const Text(
          'Pilih Alamat',
          style: TextStyle(
            color: kText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E8E8)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.addresses.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: kPrimary),
                );
              }
              return _AddressList(
                addresses: controller.addresses,
                selectedId: controller.selectedId.value,
                onSelect: controller.select,
              );
            }),
          ),
          _AddNewButton(),
        ],
      ),
    );
  }
}

class _AddressList extends StatelessWidget {
  final List<AddressModel> addresses;
  final String selectedId;
  final void Function(String) onSelect;

  const _AddressList({
    required this.addresses,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFF0F0F0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            'Alamat',
            style: TextStyle(color: kSubtext, fontSize: 13),
          ),
        ),
        ...addresses.map((addr) {
          final isSelected = addr.id == selectedId;
          return _AddressCard(
            address: addr,
            isSelected: isSelected,
            onTap: () => onSelect(addr.id),
          );
        }),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadioDot(selected: isSelected),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    address.recipient,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: kText,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '|',
                                  style: TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    address.phone,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: kSubtext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Ubah',
                              style: TextStyle(fontSize: 13, color: kSubtext),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.street,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                          height: 1.4,
                        ),
                      ),
                      Text(
                        address.city,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                          height: 1.4,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: kPrimary, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Utama',
                            style: TextStyle(
                              color: kPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? kPrimary : const Color(0xFFCCCCCC),
          width: selected ? 6 : 1.5,
        ),
        color: Colors.white,
      ),
    );
  }
}

class _AddNewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: kPrimary, size: 18),
        label: const Text(
          'Tambah Alamat Baru',
          style: TextStyle(
            color: kPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
