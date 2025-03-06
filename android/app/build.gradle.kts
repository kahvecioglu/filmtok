plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase için gerekli
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
}

android {
    namespace = "com.example.filmtok"
    compileSdk = 35 // En güncel SDK sürümünü kullan

    ndkVersion = "27.0.12077973" // Firebase için NDK sürümü

    defaultConfig {
        applicationId = "com.example.filmtok"
        minSdk = 23 // Firebase Authentication için min SDK sürümü
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Eğer release için özel bir imza yoksa, debug imzası kullanılır
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
