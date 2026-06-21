import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kPrimary, size: 20),
          onPressed: Get.back,
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: kText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TotalRow(controller: controller),
                  const _Separator(),
                  _CountdownRow(controller: controller),
                  const _Separator(),
                  if (controller.paymentType == 'bank') ...[
                    _BankSection(controller: controller),
                    const _Separator(),
                    _InstructionsSection(controller: controller),
                  ] else
                    _QrisSection(controller: controller),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _OkButton(controller: controller),
        ],
      ),
    );
  }
}

// ── Total ────────────────────────────────────────────────────────────────────

class _TotalRow extends StatelessWidget {
  final PaymentController controller;
  const _TotalRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Pembayaran',
            style: TextStyle(fontSize: 14, color: kText),
          ),
          Text(
            _fmt(controller.total),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: kPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

// ── Countdown ────────────────────────────────────────────────────────────────

class _CountdownRow extends StatelessWidget {
  final PaymentController controller;
  const _CountdownRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bayar Dalam',
            style: TextStyle(fontSize: 14, color: kText),
          ),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  controller.countdownText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Jatuh tempo ${controller.dueDate.value}',
                  style: const TextStyle(fontSize: 12, color: kSubtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bank Section ─────────────────────────────────────────────────────────────

class _BankSection extends StatelessWidget {
  final PaymentController controller;
  const _BankSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                _BankIcon(bankName: controller.bankName),
                const SizedBox(width: 12),
                Text(
                  'Bank ${controller.bankName}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No. Rek/Virtual Account',
                  style: TextStyle(fontSize: 13, color: kSubtext),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.paymentNumber,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.copyVA,
                      child: const Text(
                        'Salin',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00B09B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BankIcon extends StatelessWidget {
  final String bankName;
  const _BankIcon({required this.bankName});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'BCA': (const Color(0xFF005BAC), const Color(0xFFE8F0FB)),
      'Mandiri': (const Color(0xFF003087), const Color(0xFFE8EBF4)),
      'BNI': (const Color(0xFFFF6200), const Color(0xFFFFF0E6)),
      'BRI': (const Color(0xFF005BAA), const Color(0xFFE6EFF8)),
      'CIMB': (const Color(0xFF8B0000), const Color(0xFFFBEAEA)),
      'Permata': (const Color(0xFF006400), const Color(0xFFE6F4E6)),
      'Danamon': (const Color(0xFFCC0000), const Color(0xFFFBEAEA)),
    };
    final pair = colors[bankName] ?? (kPrimary, kPrimaryLight);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: pair.$2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          bankName.substring(0, bankName.length > 3 ? 3 : bankName.length),
          style: TextStyle(
            color: pair.$1,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ── Instructions ─────────────────────────────────────────────────────────────

class _InstructionsSection extends StatelessWidget {
  final PaymentController controller;
  const _InstructionsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bank = controller.bankName;
    final va = controller.paymentNumber;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _ExpandableInstruction(
            title: 'Petunjuk Transfer mBanking',
            initiallyExpanded: true,
            steps: _mBankingSteps(bank, va),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _ExpandableInstruction(
            title: 'Petunjuk Transfer iBanking',
            steps: _iBankingSteps(bank, va),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _ExpandableInstruction(
            title: 'Petunjuk Transfer ATM',
            steps: _atmSteps(bank, va),
          ),
        ],
      ),
    );
  }

  List<_Step> _mBankingSteps(String bank, String va) => [
    _Step('Pilih', 'm-Transfer > $bank Virtual Account.'),
    _Step('Masukkan', 'nomor Virtual Account $va dan pilih Send.'),
    _Step(
      'Periksa',
      'informasi yang tertera di layar. Pastikan Merchant adalah Parela, Total tagihan sudah benar, lalu pilih Ya.',
    ),
    _Step('Masukkan', 'PIN m-$bank Anda dan pilih OK.'),
    _Step('Simpan', 'bukti transfer sebagai konfirmasi pembayaran.'),
  ];

  List<_Step> _iBankingSteps(String bank, String va) => [
    _Step('Login', 'ke KlikBCA Individual / iBanking $bank Anda.'),
    _Step('Pilih', 'Transfer Dana > Transfer ke $bank Virtual Account.'),
    _Step('Masukkan', 'nomor Virtual Account $va lalu pilih Lanjutkan.'),
    _Step(
      'Periksa',
      'informasi yang tampil, pastikan nominal benar, lalu pilih Kirim.',
    ),
    _Step('Masukkan', 'PIN iBanking dan klik Submit.'),
  ];

  List<_Step> _atmSteps(String bank, String va) => [
    _Step('Masukkan', 'kartu ATM $bank dan PIN Anda.'),
    _Step(
      'Pilih',
      'Transaksi Lainnya > Transfer > ke Rekening $bank Virtual Account.',
    ),
    _Step('Masukkan', 'nomor Virtual Account $va lalu tekan Benar.'),
    _Step(
      'Periksa',
      'informasi yang tampil, pastikan nominal benar, lalu pilih Ya.',
    ),
    _Step('Simpan', 'struk sebagai bukti pembayaran.'),
  ];
}

class _Step {
  final String bold;
  final String rest;
  const _Step(this.bold, this.rest);
}

class _ExpandableInstruction extends StatefulWidget {
  final String title;
  final List<_Step> steps;
  final bool initiallyExpanded;

  const _ExpandableInstruction({
    required this.title,
    required this.steps,
    this.initiallyExpanded = false,
  });

  @override
  State<_ExpandableInstruction> createState() => _ExpandableInstructionState();
}

class _ExpandableInstructionState extends State<_ExpandableInstruction> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: kSubtext,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: widget.steps.asMap().entries.map((e) {
                final i = e.key + 1;
                final step = e.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == 1 ? kPrimary : const Color(0xFFE0E0E0),
                        ),
                        child: Center(
                          child: Text(
                            '$i',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: i == 1 ? Colors.white : kSubtext,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF555555),
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: '${step.bold} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: kText,
                                ),
                              ),
                              TextSpan(text: step.rest),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

// ── QRIS Section ─────────────────────────────────────────────────────────────

class _QrisSection extends StatelessWidget {
  final PaymentController controller;
  const _QrisSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE60026),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'QRIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'by GPN',
                          style: TextStyle(
                            fontSize: 11,
                            color: kSubtext,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Berlaku semua aplikasi',
                      style: TextStyle(fontSize: 11, color: kSubtext),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 16),
                QrImageView(
                  data: controller.qrData,
                  version: QrVersions.auto,
                  size: 210,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF1A1A2E),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 12),
                const Text(
                  'Parela Beauty Store',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Nasional Merchant',
                  style: TextStyle(fontSize: 12, color: kSubtext),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 13, color: kSubtext),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Scan menggunakan m-banking atau dompet digital apapun',
                  style: TextStyle(fontSize: 12, color: kSubtext),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── OK Button ────────────────────────────────────────────────────────────────

class _OkButton extends StatelessWidget {
  final PaymentController controller;
  const _OkButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isConfirming.value
                ? null
                : controller.confirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.isConfirming.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'OK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 8);
}
