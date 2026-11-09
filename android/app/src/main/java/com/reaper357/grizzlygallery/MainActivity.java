package com.reaper357.grizzlygallery;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(GalleryToolsPlugin.class);
        super.onCreate(savedInstanceState);
    }
}
