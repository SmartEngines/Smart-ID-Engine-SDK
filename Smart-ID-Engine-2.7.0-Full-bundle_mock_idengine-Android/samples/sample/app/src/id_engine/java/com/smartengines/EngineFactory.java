/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

/**
 * ID ENGINE
 */
public class EngineFactory {
    static ISession createSession(){
        return new IdSession();
    }
}
