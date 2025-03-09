# FilmTok Uygulaması - README

## 📌 Proje Açıklaması
FilmTok, kullanıcıların popüler filmleri keşfedip favorilerine ekleyebildiği bir film keşif uygulamasıdır. Kullanıcılar, Google ile giriş yaparak otomatik oturum açabilir, beğendikleri filmleri profillerinde saklayabilir ve teklif listesi gibi özel fırsatlara erişebilir.

## 📌 Kullanılan Teknolojiler ve Araçlar
- **Flutter**: Uygulamanın ana yapısını oluşturmak için kullanıldı.
- **Firebase Authentication**: Google ile giriş yapma ve oturum yönetimi sağlamak için kullanıldı.
- **Firebase Firestore**: Kullanıcı bilgileri, favori filmler ve teklif listesi gibi verileri saklamak için kullanıldı.
- **Firebase Storage (Base64)**: Profil fotoğraflarını base64 formatında Firestore'a kaydetmek için kullanıldı.
- **Provider**: Durum yönetimi için kullanıldı. Kullanıcı favori filmlerini yönetmek için kullanılıyor.
- **TMDb API**: Film bilgilerini almak için kullanıldı.
- **Font Awesome Flutter**: UI geliştirmesi için özel ikonlar kullanıldı.
- **PageView ve IndexedStack**: Sayfalar arasında geçiş yapmak için kullanıldı.

## 📌 Uygulama Özellikleri

### 🔹 Splash ve Onboarding Ekranı
- Kullanıcı uygulamayı ilk kez açtığında onboarding ekranı ile karşılaşır.
- Uygulamaya giriş yapmadan önce kısa bir tanıtım ekranı gösterilir.

### 🔹 Kullanıcı Girişi & Kayıt
- Google ile giriş yapma seçeneği bulunur.
- Kullanıcı giriş yapmışsa, uygulama açıldığında otomatik olarak oturum açılır.
- Firebase Authentication ile kullanıcı kimlik doğrulama yönetilir.

### 🔹 Ana Sayfa
- TMDb API'den rastgele bir sayfa çekilerek filmler listelenir.
- Kullanıcılar filmleri beğenebilir ve favorilere ekleyebilir.
- Sayfa yukarı/aşağı kaydırıldıkça yeni filmler yüklenir.

### 🔹 Favori Filmler
- Kullanıcı beğendiği filmleri favorilerine ekleyebilir.
- Favoriler, hem uygulama içinde Provider ile saklanır hem de Firestore'a kaydedilir.
- Kullanıcı, favori filmlerini Profil ekranında görebilir.

### 🔹 Profil Ekranı
- Kullanıcı adı, kullanıcı ID ve profil fotoğrafı gösterilir.
- Kullanıcı, profil fotoğrafını seçip Firestore'a base64 formatında kaydedebilir.
- Kullanıcı favori filmlerini burada listeleyebilir.

### 🔹 Teklif Listesi
- Kullanıcılara özel teklifler ve avantajlar sunulur.
- Teklif listesi ayrı bir ekranda gösterilir ve Firebase Firestore'dan çekilir.

## 📌 Kurulum & Çalıştırma
1. **Gerekli Bağımlılıkları Yükleyin**
   ```sh
   flutter pub get
   ```
2. **Firebase'i Yapılandırın**
   - Firebase projesini oluşturun.
   - `google-services.json` dosyasını `android/app` klasörüne ekleyin.
   - Firebase Authentication ve Firestore'u etkinleştirin.

3. **TMDb API Anahtarınızı Ekleyin**
   - TMDb'den bir API anahtarı alın ve `movieapi.dart` dosyanıza ekleyin.

4. **Uygulamayı Başlatın**
   ```sh
   flutter run
   ```

## 📌 Gelecek Güncellemeler
- Kullanıcıların yorum yapabileceği bir sistem
- Dark/Light mod desteği
- Film detay sayfası ile daha fazla bilgi sunulması


## 📌 Uygulamanın kullanım videosu
      https://drive.google.com/file/d/17Yz4iqaR5lQ12anwXO-tu6FXoJD-342j/view?usp=sharing
      

