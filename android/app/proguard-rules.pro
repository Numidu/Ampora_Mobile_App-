# Fix for Conscrypt / OkHttp missing classes
-dontwarn org.conscrypt.**
-dontwarn okhttp3.internal.platform.ConscryptPlatform

# Prevent PayHere SDK classes from being stripped or obfuscated
-keep class lk.payhere.** { *; }
-keep interface lk.payhere.** { *; }
-dontwarn lk.payhere.**

# Additional fixes for runtime crashes
-keep class com.google.gson.** { *; }
-keepattributes Signature, *Annotation*, EnclosingMethod