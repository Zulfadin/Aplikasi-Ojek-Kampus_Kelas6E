import 'package:flutter/material.dart';
import 'package:untitled2/theme.dart';

class RatingDriverPage extends StatefulWidget {
  final String driverName;

  const RatingDriverPage({required this.driverName, Key? key}) : super(key: key);

  @override
  _RatingDriverPageState createState() => _RatingDriverPageState();
}

class _RatingDriverPageState extends State<RatingDriverPage> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() {
    // Logic untuk submit rating bisa ditambahkan disini
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terima kasih atas rating Anda!')),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beri Rating Driver', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Bagaimana pengalaman Anda dengan ${widget.driverName}?',
                style: AppTextStyles.sectionHeader),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Tulis komentar (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _rating == 0 ? null : _submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Kirim Rating', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
