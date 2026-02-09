/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.kotlin_sample

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.smartengines.core.engine.id.Attribute
import com.smartengines.core.engine.id.TextField
import com.smartengines.core.engine.id.IdEngineSession
import com.smartengines.core.engine.id.IdResultData
import com.smartengines.core.engine.id.ImageField
import com.smartengines.core.engine.Session
import com.smartengines.core.engine.id.parse
import com.smartengines.kotlin_sample.ui.theme.Kotlin_sampleTheme

/**
 * TAKE THE SESSION => GET AND SHOW THE CURRENT RESULT
 */

@Composable
fun IdResultScreen(session: Session) {
    val idResultData = remember{
        (session as IdEngineSession).idSession.GetCurrentResult()
            .parse()
            .also{
                Model.setPassportKey(it?.calculatePassportKey())
            }
    }

    // Screen
    idResultData?.let {
        IdResultScreen(resultData = it)
    }?:run{
        NoResult()
    }
}

@Composable
private fun NoResult() {
    Text("Document not found")
}

@Composable
private fun IdResultScreen(resultData: IdResultData) {
    with(resultData) {
        Column(modifier = Modifier
            .verticalScroll(rememberScrollState())
            .fillMaxSize()
            .padding(horizontal = 5.dp)

        ) {
            // DOC TYPE
            Text(
                text = docType,
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Center,
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold
            )

            // NFC
            Section("RFID TAG")
            NfcScreen()

            // TEXT FIELDS
            Section("TEXT FIELDS")
            textFields.forEach {
                FieldRow(it)
            }

            // IMAGES
            Section("IMAGES")
            images.forEach {
                ImageRow(it)
            }

            // FORENSIC FIELDS
            Section("FORENSIC FIELDS")
            forensicCheckFields.forEach {
                FieldRow(it)
            }
            forensicTextFields.forEach {
                FieldRow(it)
            }
            forensicImages.forEach {
                ImageRow(it)
            }


        }
    }
}

@Composable
private fun Section(text:String){
    Text(
        text = text,
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(top = 20.dp)
    )
}

@Composable
private fun FieldRow(textField: TextField) {
    with(textField) {
        Card(Modifier.fillMaxWidth()){ Column(Modifier.fillMaxWidth().padding(5.dp)) {
            // key + isAccepted
            Row(Modifier.fillMaxWidth()) {
                Text(text = key,
                    modifier = Modifier.weight(1f))
                Text(text = isAccepted.toString())
            }
            // Value
            Text(text = value, fontWeight = FontWeight.Bold)
            // Attributes
            AttributesRow(attributes = attr)
        }}
        Spacer(modifier = Modifier.height(8.dp))
    }
}
@Composable
private fun AttributesRow(attributes: List<Attribute>) {
    with(attributes) {
        if (isNotEmpty()){
            Column(
                Modifier
                    .fillMaxWidth()
                    .padding(start = 30.dp)
            ) {
                forEach {
                    Text(
                        text = "${it.key} : ${it.value}",
                        style = MaterialTheme.typography.bodySmall
                    )
                }
            }
        }
    }
}

@Composable
private fun ImageRow(imageField: ImageField) {
    with(imageField) {
        Card(Modifier.fillMaxWidth()){ Column(Modifier.fillMaxWidth().padding(5.dp)) {
            // key
            Text(text = key)
            // Value
            Image(bitmap = value.asImageBitmap(), contentDescription = "")
            // Attributes
            AttributesRow(attributes = attr)
        }}
        Spacer(modifier = Modifier.height(10.dp))
    }
}

//--------------------------------------------------------------------------------------------------
// PREVIEW
@Preview(showBackground = true)
@Composable
private fun ReadyStateScreen_Preview() {
    Kotlin_sampleTheme {
        IdResultScreen(
            resultData = IdResultData(
                docType = "cze.passport.type1",
                textFields  = listOf(
                    TextField("birth_date","29.10.1981",true,
                        listOf(Attribute("mono_score", "-1.5"), Attribute("att_sample", "sample text"))
                    ),
                    TextField("birth_place","DAČICE",true,
                        listOf(Attribute("mono_score", "-1.5"), Attribute("att_key", "key sample text"))
                    )
                ),
                images = emptyList(),
                forensicCheckFields = emptyList(),
                forensicTextFields = emptyList(),
                forensicImages = emptyList(),
                )
        )
    }
}
