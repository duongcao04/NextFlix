import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể mở liên kết: $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Liên hệ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                text: 'Chào mừng bạn đến với trang ',
                style: TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  TextSpan(
                    text: 'Liên Hệ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ' của RoPhim!\nChúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn để mang lại trải nghiệm tốt nhất khi sử dụng dịch vụ. '
                        'Nếu có bất kỳ câu hỏi, góp ý, hoặc yêu cầu hỗ trợ nào, hãy liên hệ với chúng tôi qua các thông tin dưới đây.',
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),

            const Text(
              '1. Thông Tin Liên Hệ Chính',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email hỗ trợ khách hàng:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SelectableText(
              'support@rophim.net',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Vấn đề tài khoản: Quên mật khẩu, không thể truy cập, và các vấn đề liên quan đến tài khoản.\n'
              '• Hỗ trợ kỹ thuật: Sự cố khi xem phim, chất lượng video hoặc các lỗi khác khi sử dụng trang web.\n'
              '• Đóng góp ý kiến: Chúng tôi trân trọng mọi ý kiến đóng góp từ bạn để nâng cao chất lượng dịch vụ.',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email liên hệ về Chính Sách Riêng Tư:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SelectableText(
              'privacy@rophim.net',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mọi thắc mắc liên quan đến bảo mật thông tin và chính sách riêng tư của RoPhim.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),

            const Text(
              '2. Liên Hệ Qua Mạng Xã Hội',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ngoài email, bạn cũng có thể liên hệ và cập nhật thông tin mới nhất từ RoPhim qua các kênh mạng xã hội của chúng tôi:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () async {
                await _launchUrl(context, 'https://t.me/rophimzone');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '📨 Telegram: https://t.me/rophimzone',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                await _launchUrl(
                  context,
                  'https://www.facebook.com/rophimcom/',
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '📘 Facebook: https://www.facebook.com/rophimcom/',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
