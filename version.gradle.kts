/**
 * Version management system based on git tags
 * Supports semantic versioning (semver)
 *
 * Usage:
 * - Create git tag: git tag v1.2.3
 * - Build will automatically use this version
 * - versionCode calculated from major.minor.patch
 */

fun getGitTag(): String {
    return try {
        val process = Runtime.getRuntime().exec("git describe --tags --always --dirty")
        process.inputStream.bufferedReader().readText().trim()
    } catch (e: Exception) {
        "v1.0.0-dev"
    }
}

fun getGitCommitCount(): Int {
    return try {
        val process = Runtime.getRuntime().exec("git rev-list --count HEAD")
        process.inputStream.bufferedReader().readText().trim().toIntOrNull() ?: 1
    } catch (e: Exception) {
        1
    }
}

data class Version(
    val major: Int,
    val minor: Int,
    val patch: Int,
    val suffix: String = ""
) {
    val versionName: String
        get() = "$major.$minor.$patch${if (suffix.isNotEmpty()) "-$suffix" else ""}"

    val versionCode: Int
        get() = major * 10000 + minor * 100 + patch
}

fun parseVersion(tag: String): Version {
    val cleanTag = tag.removePrefix("v").removeSuffix("-dirty")
    val parts = cleanTag.split("-")
    val versionPart = parts[0]
    val suffix = if (parts.size > 1) parts.drop(1).joinToString("-") else ""

    val numbers = versionPart.split(".")
    return Version(
        major = numbers.getOrNull(0)?.toIntOrNull() ?: 1,
        minor = numbers.getOrNull(1)?.toIntOrNull() ?: 0,
        patch = numbers.getOrNull(2)?.toIntOrNull() ?: 0,
        suffix = suffix
    )
}

val appVersion = parseVersion(getGitTag())

val finalVersionCode = if (appVersion.versionCode == 0) {
    getGitCommitCount()
} else {
    appVersion.versionCode
}

// Set extra properties for project
project.extensions.extraProperties.set("versionName", appVersion.versionName)
project.extensions.extraProperties.set("versionCode", finalVersionCode)

println("═══════════════════════════════════════")
println("  Russify Version Info")
println("═══════════════════════════════════════")
println("  Version Name: ${appVersion.versionName}")
println("  Version Code: $finalVersionCode")
println("  Git Tag: ${getGitTag()}")
println("═══════════════════════════════════════")
