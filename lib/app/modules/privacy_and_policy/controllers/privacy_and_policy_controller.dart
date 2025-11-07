import 'package:cema_mobile/app/data/model/policy.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PrivacyController extends GetxController {
  final sections = <PolicySection>[
    PolicySection(
      title: 'Pendahuluan',
      body:
          'Selamat datang di aplikasi kami. Privasi dan keamanan data Anda adalah prioritas utama. Dokumen ini menjelaskan bagaimana kami mengumpulkan, menggunakan, menyimpan, dan melindungi informasi Anda. Kami berkomitmen membuat kebijakan yang jelas, mudah dibaca, dan ramah pengguna.',
    ),
    PolicySection(
      title: 'Data yang Dikumpulkan',
      body:
          'Kami dapat mengumpulkan beberapa jenis informasi, termasuk: \n• Data identitas (nama, email) jika Anda mendaftar atau menghubungi kami.\n• Data teknis (jenis perangkat, versi sistem operasi, ID perangkat).\n• Data penggunaan (halaman yang dikunjungi, fitur yang dipakai, waktu interaksi).',
    ),
    PolicySection(
      title: 'Tujuan Penggunaan Data',
      body:
          'Data digunakan untuk: \n• Menyediakan dan memperbaiki layanan.\n• Personalisasi pengalaman pengguna (rekomendasi, preferensi).\n• Komunikasi penting terkait akun atau update fitur.\n• Analitik untuk memahami bagaimana aplikasi digunakan dan memperbaiki performa.',
    ),
    PolicySection(
      title: 'Pembagian dan Pengungkapan',
      body:
          'Kami tidak akan menjual data pribadi Anda. Data hanya dapat dibagikan dengan pihak ketiga dalam kondisi berikut: \n• Penyedia layanan yang membantu operasional (mis. hosting, analitik).\n• Jika diwajibkan secara hukum atau untuk melindungi hak dan keselamatan kami dan pengguna lain.\nSemua mitra dijaga agar mematuhi standar privasi yang memadai.',
    ),
    PolicySection(
      title: 'Cookies & Teknologi Serupa',
      body:
          'Aplikasi dapat menggunakan cookie ringan atau penyimpanan lokal untuk menyimpan preferensi dan meningkatkan pengalaman pengguna. Anda dapat menghapus atau menonaktifkan cookie melalui pengaturan perangkat, namun beberapa fitur mungkin tidak berfungsi optimal.',
    ),
    PolicySection(
      title: 'Keamanan Data',
      body:
          'Kami menerapkan langkah-langkah teknis dan organisasi untuk melindungi data dari akses tidak sah, perubahan, atau penghapusan. Namun, tidak ada metode transmisi data melalui internet yang 100% aman; kami terus memperbarui praktik keamanan sesuai standar industri.',
    ),
    PolicySection(
      title: 'Hak Pengguna',
      body:
          'Anda berhak untuk meminta akses, koreksi, atau penghapusan data pribadi Anda. Jika ingin mengajukan permintaan tersebut, silakan hubungi tim kami melalui kontak yang tersedia di bawah.',
    ),
    PolicySection(
      title: 'Privasi Anak-anak',
      body:
          'Aplikasi ini tidak ditujukan untuk anak-anak di bawah 13 tahun. Kami tidak sengaja mengumpulkan data dari anak-anak. Jika terlanjur terjadi, mohon hubungi kami untuk penghapusan data.',
    ),
    PolicySection(
      title: 'Perubahan Kebijakan',
      body:
          'Kami dapat memperbarui kebijakan ini sewaktu-waktu. Perubahan signifikan akan diinformasikan melalui notifikasi in-app atau email. Tanggal pembaruan terakhir akan dicantumkan di bagian bawah halaman.',
    ),
    PolicySection(
      title: 'Kontak',
      body:
          'Jika Anda memiliki pertanyaan, keluhan, atau permintaan terkait privasi, hubungi: \nEmail: privacy@contohapp.id\nAlamat: Jl. Contoh No.1, Bandung, Indonesia',
    ),
  ].obs;

  final lastUpdated = '08 November 2025'.obs;
}
