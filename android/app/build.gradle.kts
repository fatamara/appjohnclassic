plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "johnclassic.fata.com.johnclassic"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "johnclassic.fata.com.johnclassic"
        minSdk = 26
        targetSdk = 35
        versionCode = 7
        versionName = "1.0.1"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    signingConfigs {
        create("release") {
            storeFile = file("taxi.jks")
            storePassword = "ThiernoSouare1995"
            keyAlias = "taxiagent"
            keyPassword = "ThiernoSouare1995"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    // ✅ Ajoute le SDK Pushy Natif
    implementation("me.pushy:sdk:1.0.115")
}

flutter {
    source = "../.."
}
