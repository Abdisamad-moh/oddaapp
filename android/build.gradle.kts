buildscript {
    extra.apply {
        set("flutter.compileSdkVersion", 36)
        set("flutter.minSdkVersion", 23)
        set("flutter.targetSdkVersion", 34)
        set("flutter.ndkVersion", "27.0.12077973")
        set("flutter.versionCode", 1)
        set("flutter.versionName", "1.0")
    }

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.2.2") // Updated
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22") // Updated
        classpath("com.google.gms:google-services:4.4.0") // Added for Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
