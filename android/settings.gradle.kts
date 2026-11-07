pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.3.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

include(":app")

dependencyResolutionManagement {
    // ÐœÐµÐ½ÑÐµÐ¼ Ñ€ÐµÐ¶Ð¸Ð¼ Ð½Ð° PREFER_PROJECT, Ñ‡Ñ‚Ð¾Ð±Ñ‹ Ñ€Ð°Ð·Ñ€ÐµÑˆÐ¸Ñ‚ÑŒ Ñ€ÐµÐ¿Ð¾Ð·Ð¸Ñ‚Ð¾Ñ€Ð¸Ð¸ Ð¸Ð· build.gradle.kts
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        google()
        mavenCentral()
        // Ð—ÐµÑ€ÐºÐ°Ð»Ð° Ð´Ð»Ñ Ð¾Ð±Ñ…Ð¾Ð´Ð° Ð±Ð»Ð¾ÐºÐ¸Ñ€Ð¾Ð²Ð¾Ðº
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/mavenCentral") }
    }
}