-keepattributes EnclosingMethod

-optimizationpasses 5          # 指定代码的压缩级别
-dontusemixedcaseclassnames   # 是否使用大小写混合
-dontpreverify           # 混淆时是否做预校验
-verbose                # 混淆时是否记录日志
# 混淆时所采用的算法
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*



#友盟
-keep class com.umeng.** {*;}

-keep class org.repackage.** {*;}

-keep class com.uyumao.** { *; }

-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

#JNI
-keepclasseswithmembernames class * {
    native <methods>;
}

#显示行号
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# Dio 相关
-keep class com.dio.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class retrofit2.** { *; }

# 保持 Retrofit 相关
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.yourpackage.model.** { *; } # 保持你的数据模型类
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

-keep class io.flutter.plugins.cronet_http.** { *; }
-keep class java.net.URL { *; }
-keep class java.util.concurrent.Executors { *; }
-keep class org.chromium.net.** { *; }
-keep class io.flutter.plugins.cronet_http.UrlRequestCallbackProxy { *; }

-dontwarn com.google.firebase.perf.network.**
-keepclassmembers class * extends com.google.android.gms.internal.firebase-perf.zzbz {
  <fields>;
}
-keepclassmembers class * extends com.google.android.gms.internal.measurement.zzzs {
  <fields>;
}
-dontwarn com.google.firebase.components.Component$Instantiation
-keep public class com.google.firebase.* {*;}

-keepclassmembers class com.google.android.gms.common.api.internal.BasePendingResult {
  com.google.android.gms.common.api.internal.BasePendingResult$ReleasableResultGuardian mResultGuardian;
}