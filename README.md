# Flutter Group & To-Do List App

Aplikasi Flutter untuk mengelola grup dan to-do list, dengan fitur autentikasi pengguna, penyimpanan data menggunakan Firebase Firestore, dan notifikasi berbasis **Firebase** dan **Awesome Notifications**. Aplikasi ini memungkinkan pengguna untuk membuat grup, bergabung, mengelola tugas, serta menerima notifikasi terkait aktivitas grup dan tugas.

## Fitur Utama

<div align="center">
   <img src="https://github.com/user-attachments/assets/593e596c-c368-4c27-9684-853ae7115544" width="300"/>
   <img src="https://github.com/user-attachments/assets/3304f279-29fe-4e91-932d-e226a51e92b6" width="300"/>
   <img src="https://github.com/user-attachments/assets/41b92f28-4a46-4fcd-bb24-f46d45c8ff13" width="300"/>
   <img src="https://github.com/user-attachments/assets/05dc9a6e-06de-4784-a358-2da2e0647c55" width="300"/>
   <img src="https://github.com/user-attachments/assets/1bfbc2a3-b1e2-4375-8ae1-c732921fae64" width="300"/>
</div>

### **Login Page**
- Halaman untuk autentikasi pengguna menggunakan **Firebase Authentication**.
- Pengguna dapat login dengan email dan password yang terdaftar di Firebase.

### **Register Page**
- Halaman pendaftaran pengguna baru.
- Pengguna dapat membuat akun menggunakan email dan password.

### **Group Page**
- **Menampilkan Daftar Grup**: Halaman utama yang menampilkan grup yang sudah ada.
- **Membuat Grup**: Pengguna dapat membuat grup baru.
- **Bergabung dan Keluar dari Grup**: Pengguna dapat bergabung dengan grup yang ada atau keluar dari grup.

### **To-Do List Page**
- **Menampilkan Daftar Tugas**: Menampilkan tugas yang terkait dengan grup yang dipilih.
- **Membuat dan Menghapus Tugas**: Pengguna dapat membuat tugas baru dan menghapus tugas yang sudah ada.

### **Awesome Notifications**
- **Notifikasi Join/Leave**: Mengirim notifikasi saat pengguna bergabung atau keluar dari grup.
- **Notifikasi Terjadwal**: Mengirim notifikasi terjadwal berdasarkan tanggal jatuh tempo tugas di grup.

## Teknologi yang Digunakan

Aplikasi ini dibangun dengan beberapa teknologi utama untuk memberikan fungsionalitas terbaik:

- **Flutter**: Framework utama untuk membangun aplikasi mobile cross-platform.
- **Firebase Firestore**: Untuk menyimpan data grup dan to-do list secara real-time.
- **Firebase Authentication**: Untuk autentikasi pengguna (login, register).
- **Awesome Notifications**: Untuk mengirimkan notifikasi kepada pengguna, baik untuk peristiwa langsung (join/leave) maupun notifikasi terjadwal berdasarkan due date tugas.
