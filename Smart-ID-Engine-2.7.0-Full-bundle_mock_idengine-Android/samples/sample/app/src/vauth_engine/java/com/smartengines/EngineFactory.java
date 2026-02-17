/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

/**
 * VA ENGINE
 */
public class EngineFactory {
    static ISession createSession(){
        return new VaSession();
    }
}
