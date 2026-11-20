plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Uygulama ayarı (D52): kökteki git-ignored `.env` her derlemede okunur ve BuildConfig.ENV olarak
// APK'ya girer; Dart açılışta kanal üzerinden alır. Böylece `flutter run`, ▶ ve `flutter build`
// ek bayrak istemez. Yalnız istemcide açık olması tasarım gereği serbest olan anahtarlar alınır.
val envKeys = listOf(
    "SUPABASE_URL", "SUPABASE_ANON_KEY", "GOOGLE_WEB_CLIENT_ID",
    "FIREBASE_API_KEY", "FIREBASE_APP_ID", "FIREBASE_SENDER_ID", "FIREBASE_PROJECT_ID",
)
val envFile = rootProject.file("../.env")
val envValues = (if (envFile.exists()) envFile.readLines() else emptyList())
    .map { it.trim() }
    .filter { it.isNotEmpty() && !it.startsWith("#") && it.contains("=") }
    .map { it.split("=", limit = 2) }
    .associate { (k, v) -> k.trim() to v.trim().trim('"', '\'') }
    .filterKeys { it in envKeys }
    .filterValues { it.isNotEmpty() && !it.contains('"') && !it.contains('\\') }

android {
    namespace = "com.mirhatuguzlu.neuroplan"
    // flutter_local_notifications 23 androidx.core 1.19 ister (compileSdk ≥ 37); targetSdk Flutter varsayılanı.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications zamanlanmış bildirimler için ister.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mirhatuguzlu.neuroplan"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        buildConfigField(
            "String[]",
            "ENV",
            envValues.entries.joinToString(", ", "{", "}") { "\"${it.key}=${it.value}\"" },
        )
    }

    buildFeatures {
        buildConfig = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
