allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")

    // Fix for missing namespace in AGP 8.0+
    // Only apply to Android Libraries (like isar_flutter_libs), not the App itself
    plugins.withId("com.android.library") {
        val android = extensions.getByName("android") as com.android.build.gradle.LibraryExtension
        if (android.namespace == null) {
            // Namespace must be a valid Java package name (no hyphens)
            android.namespace = project.group.toString().replace("-", "_")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
