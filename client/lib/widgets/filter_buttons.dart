import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  const FilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            'Bạn đang quan tâm gì?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                FilterButton(label: 'Marvel', color: Colors.red),
                FilterButton(label: '4K', color: Colors.blue),
                FilterButton(label: 'Sitcom', color: Colors.green),
                FilterButton(label: 'Lồng Tiếng', color: Colors.purple),
                FilterButton(label: 'Xuyên không', color: Colors.orange),
                FilterButton(label: 'Cổ trang', color: Colors.cyan),
                FilterButton(label: '+4 Chủ đề', color: Colors.pink),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final Color color;

  const FilterButton({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: 150,
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
