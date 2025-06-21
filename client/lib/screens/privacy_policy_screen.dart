import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chính sách bảo mật'),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chính sách bảo mật',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Rophim cam kết không bán, trao đổi hoặc chia sẻ thông tin cá nhân của bạn với bất kỳ bên thứ ba nào, ngoại trừ trong các trường hợp sau:\n\n'
                ' • Với Sự Đồng Ý Của Bạn: Chúng tôi chỉ chia sẻ thông tin cá nhân khi có sự đồng ý rõ ràng của bạn.\n\n'
                ' • Đối Tác và Nhà Cung Cấp Dịch Vụ: Chia sẻ thông tin với các đối tác và nhà cung cấp dịch vụ tin cậy để hỗ trợ trong việc cung cấp dịch vụ, xử lý thanh toán, và phân tích dữ liệu.\n\n'
                ' • Tuân Thủ Pháp Luật: Rophim có thể tiết lộ thông tin cá nhân nếu được yêu cầu theo quy định pháp luật hoặc để bảo vệ quyền lợi, tài sản và an toàn của công ty và người dùng.\n\n'
                'Bảo mật thông tin cá nhân\n\n'
                'Chúng tôi áp dụng các biện pháp kỹ thuật và tổ chức để bảo vệ thông tin cá nhân của bạn khỏi việc mất mát, lạm dụng, truy cập trái phép, tiết lộ và thay đổi. Tuy nhiên, không có phương pháp nào là tuyệt đối an toàn. Chúng tôi cam kết cải tiến bảo mật để bảo vệ thông tin của bạn.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Add more content here as needed
            ],
          ),
        ),
      ),
    );
  }
}
