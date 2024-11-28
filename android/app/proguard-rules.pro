# Keep classes related to flutter_local_notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep type parameters for Gson or similar serialization
-keepattributes Signature
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep generic type information used by Gson
-keepattributes Signature
-keepattributes RuntimeVisibleAnnotations

# Keep everything in the flutter_local_notifications package
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Gson specific rules
-keep class com.google.gson.** { *; }
-keep class sun.misc.Unsafe { *; }