// Top-level build file where you can add configuration options common to all sub-projects/modules.

// Apply version management
apply(from = "version.gradle.kts")

plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.compose) apply false
    alias(libs.plugins.kotlin.serialization) apply false
}

// Task to print version information
tasks.register("printVersion") {
    doLast {
        val appVersion = project.extensions.extraProperties
        val versionName = appVersion.get("versionName") as? String ?: "unknown"
        val versionCode = appVersion.get("versionCode") as? Int ?: 0

        println("═══════════════════════════════════════")
        println("  Russify Android Version")
        println("═══════════════════════════════════════")
        println("  Version Name: $versionName")
        println("  Version Code: $versionCode")
        println("═══════════════════════════════════════")
    }
}