# Okul Yönetim Sistemi (School Management System)

Bu proje, **Flutter** kullanılarak geliştirilmiş kapsamlı bir okul yönetim uygulamasıdır. Öğretmenler, veliler ve kurum yöneticileri için özel arayüzler ve işlevler sunar.

## 🚀 Proje Hakkında

Uygulama temel olarak 3 farklı kullanıcı rolü üzerine kurulmuştur:

1.  **Kurum (Admin)**: Sistem genelini yönetir, öğretmen ve öğrenci kayıtlarını yapar, tüm okulun not ve ödev durumlarını görüntüler.
2.  **Öğretmen**: Öğrencilerine ödev atayabilir, gönderilen ödevleri kontrol edip puanlayabilir (grading) ve sınıf istatistiklerini görebilir.
3.  **Veli**: Öğrencinin ödevlerini takip eder, tamamlanan ödevleri sisteme yükler ve öğretmen notlarını görüntüler.

## 🛠 Kullanılan Teknolojiler ve Kütüphaneler

Proje altyapısında aşağıdaki teknolojiler kullanılmaktadır:

-   **Flutter & Dart**: Mobil uygulama geliştirme framework'ü.
-   **Firebase**: Backend servisleri için (Authentication ve Database).
    -   `cloud_firestore`: Veritabanı yönetimi (NoSQL).
    -   `firebase_core`: Firebase başlatma ve yapılandırma.
-   **Diğer Paketler**:
    -   `intl`: Tarih ve saat formatlama işlemleri için.
    -   `url_launcher`: Harici bağlantıları (ödev dosyaları vb.) açmak için.

## 📂 Proje Yapısı

Uygulama modüler bir yapıda geliştirilmiştir:

-   `lib/kurum/`: Kurum yöneticisi ile ilgili sayfalar (Profil, Ayarlar, Girilen Notlar).
-   `lib/ogretmen/`: Öğretmen paneli, ödev atama, not girişi (Not Ver) sayfaları.
-   `lib/veli/`: Veli paneli, ödev takibi ve ödev tamamlama işlemleri.

## ✨ Temel Özellikler ve Metotlar

### Veri Yönetimi
Uygulama verileri **Firestore** üzerinde `collection` ve `document` yapısı ile tutulur.
-   `StreamBuilder`: Verilerin anlık (real-time) olarak güncellenmesi ve listelenmesi için yoğun olarak kullanılmıştır.
-   `add()`: Yeni ödev, not veya kullanıcı ekleme işlemleri için kullanılır.
-   `update()`: Mevcut verilerin (örneğin bir notun) güncellenmesi için kullanılır.
-   `delete()`: Silinmesi gereken kayıtlar (tamamlanan ödevlerin bekleyen listesinden kaldırılması vb.) için kullanılır.

### Öne Çıkan Fonksiyonlar
-   **Ödev Tamamlama**: Veliler `OdevlerimVeli` sayfasında "Ödevi Tamamla" butonuna bastığında, veri `bekleyenOdevler` koleksiyonundan silinir ve eşzamanlı olarak hem `gonderilenOdevler` hem de `notlar` koleksiyonuna eklenir. `Future.wait` kullanılarak bu işlemlerin paralel ve güvenli bir şekilde yapılması sağlanır.
-   **Not Girişi**: Öğretmenler `OgretmenNotPage` üzerinden öğrencilere not verebilir.

## 🏁 Kurulum (Getting Started)

Projeyi yerel ortamınızda çalıştırmak için:

1.  Repoyu klonlayın.
2.  Gerekli paketleri yükleyin:
    ```bash
    flutter pub get
    ```
3.  Uygulamayı çalıştırın:
    ```bash
    flutter run
    ```

> **Not**: Bu projenin çalışması için geçerli bir `google-services.json` (Android) veya `GoogleService-Info.plist` (iOS) dosyasının proje dizininde bulunması gerekmektedir.
