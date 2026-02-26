package com.smartengines.kotlin_sample

sealed interface NfcDataCheckState {
    data object Empty : NfcDataCheckState
    data object Working : NfcDataCheckState
    data class Ready(val checks: Map<String,String>) : NfcDataCheckState
    data class Error(val error: String) : NfcDataCheckState
}