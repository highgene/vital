package com.hhwy.vital.common.utils;

import org.springframework.context.ApplicationContext;

import java.util.Locale;

/**
 * Created by zbx on 16-9-3.
 */
public class ConfigHelper {
    private static ApplicationContext ctx = SpringContextHolder.getApplicationContext();

    public static String getConfig(String key){
        String message = ctx.getMessage(key, new String[]{key}, Locale.getDefault());
        return message;
    }
}
