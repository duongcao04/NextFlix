import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🇻🇳 Hoàng Sa & Trường Sa là của Việt Nam!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 40),
              const SizedBox(width: 8),
              Column(
                children: const [
                  Text(
                    'NextFlix',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Phim hay',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: const [
              Icon(FontAwesomeIcons.telegram, color: Colors.white),
              Icon(FontAwesomeIcons.facebook, color: Colors.white),
              Icon(FontAwesomeIcons.tiktok, color: Colors.white),
              Icon(FontAwesomeIcons.discord, color: Colors.white),
              Icon(FontAwesomeIcons.instagram, color: Colors.white),
              Icon(FontAwesomeIcons.google, color: Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            alignment: WrapAlignment.center,
            children: const [
              Text(
                'Hỏi-Đáp',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Chính sách bảo mật',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Điều khoản sử dụng',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Giới thiệu',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Liên hệ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 16,
            children: const [
              Text(
                'Dongphim',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                'Gienphim',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                'Motphim',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                'Subnhanh',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'NextFlix – Phim hay - Trang xem phim online chất lượng cao miễn phí Vietsub, thuyết minh, lồng tiếng full HD. Hơn 10.000 phim lẻ, phim bộ, phim hoạt hình từ Việt Nam, Hàn Quốc, Trung Quốc, Thái Lan, Mỹ... hỗ trợ 4K!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            '@ 2025 NextFlix',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
