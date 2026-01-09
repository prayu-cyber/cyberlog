package com.example.odd_even_app;

import android.os.Build;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "device_info_channel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL
        ).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getDeviceInfo")) {
                        HashMap<String, String> map = new HashMap<>();
                        map.put("model", Build.MODEL);
                        map.put("manufacturer", Build.MANUFACTURER); // ✅ ADDED
                        map.put("version", Build.VERSION.RELEASE);
                        result.success(map);
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }
}
