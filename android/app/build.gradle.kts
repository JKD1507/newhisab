plugins {
    id("com.android.application")
    id("kotlin-android")
    // REMOVED the dev.flutter plugin ID to stop the crash at line 1
}

// THIS PART MANUALLY LINKS TO THE FLUTTER SDK ALREADY ON YOUR DISK
val localProperties = java.util.Properties()
val localPropertiesFile = rootProject.file("../local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}
val flutterRoot = localProperties.getProperty("flutter.sdk")
apply(from = "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle")

android {
    namespace = "com.jk.hisabapp"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.jk.hisabapp"
        minSdkVersion(21)
        targetSdkVersion(34)
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
