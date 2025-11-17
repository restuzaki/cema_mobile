import 'package:flutter/material.dart';

class TaskManagerPage extends StatelessWidget {
  const TaskManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Asep Toktok",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Project Manager",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.notifications, color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      const CircleAvatar(
                        radius: 22,
                        child: Icon(Icons.people_alt),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Ekspor Portofolio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_outward, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  _tabItem("All", isActive: true),
                  const SizedBox(width: 20),
                  _tabItem("Berlangsung"),
                  const SizedBox(width: 20),
                  _tabItem("Selesai"),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                height: 3,
                width: 24,
                color: Colors.black,
                margin: const EdgeInsets.only(left: 0, top: 2),
              ),

              const SizedBox(height: 20),

              _projectCard(
                title: "Project Name",
                phase: "Phase",
                client: "Client name",
                badge: "Berisiko",
                badgeColor: Colors.yellow.shade700,
                cpi: "0.91",
                spi: "1.1",
              ),

              const SizedBox(height: 14),

              _projectCard(
                title: "Project Name",
                phase: "Phase",
                client: "Client name",
                badge: "Darurat",
                badgeColor: Colors.red.shade700,
                cpi: "0.8",
                spi: "1.1",
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabItem(String label, {bool isActive = false}) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        color: isActive ? Colors.black : Colors.grey,
      ),
    );
  }

  Widget _projectCard({
    required String title,
    required String phase,
    required String client,
    required String badge,
    required Color badgeColor,
    required String cpi,
    required String spi,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.circle, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "$phase   |   $client",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _scoreBox("CPI", cpi, Colors.orange.shade100),
                  const SizedBox(width: 12),
                  _scoreBox("SPI", spi, Colors.green.shade100),
                ],
              ),
              Row(
                children: const [
                  Text(
                    "Lihat Detail",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreBox(String title, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
