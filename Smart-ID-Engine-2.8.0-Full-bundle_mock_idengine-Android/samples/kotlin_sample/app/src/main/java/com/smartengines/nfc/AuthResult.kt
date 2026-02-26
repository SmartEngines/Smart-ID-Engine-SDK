/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.nfc

sealed interface AuthResult {
    data object Passed                   : AuthResult
    data class  Failed(val error:String) : AuthResult
}