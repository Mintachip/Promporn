import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: const Color.fromARGB(255, 218, 239, 247),
      ),
      body: Container(
        // ครอบ Scaffold ด้วย Container สำหรับพื้นหลัง
        width: double.infinity, // ใช้พื้นที่เต็มความกว้าง
        height: double.infinity, // ใช้พื้นที่เต็มความสูง
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // ระบุรูปภาพพื้นหลัง
            fit: BoxFit.cover, // ขยายภาพให้เต็มพื้นที่
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'รายละเอียด: ${product['description']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'ราคา: ${product['price']} บาท',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'จำนวน: ${product['quantity']}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
