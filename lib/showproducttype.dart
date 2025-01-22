import 'package:flutter/material.dart';
import 'package:onlinedb_promporn/showfiltertype.dart';

class ProductProductType extends StatelessWidget {
  final List<String> categories = ["Electronics", "Clothing", "Food", "Books"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 218, 239, 247),
          title: Text('ประเภทสินค้า'),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 209,
                57), // ใส่สีพื้นหลัง (สามารถเปลี่ยนได้ตามต้องการ)
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // ถ้ามีรูปภาพพื้นหลัง
              fit: BoxFit.cover, // ทำให้ภาพขยายเต็มจอ
            ),
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowFilterType(category: categories[index]),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(
                        255, 255, 255, 255), // สีพื้นหลังของการ์ด
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Icon(
                        Icons.shopping_cart,
                        size: 40,
                        color: Color.fromARGB(255, 255, 188, 188),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
