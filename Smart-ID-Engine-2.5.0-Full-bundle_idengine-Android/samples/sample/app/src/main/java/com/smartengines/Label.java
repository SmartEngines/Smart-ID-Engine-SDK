/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import androidx.databinding.ObservableField;

// The Label field is used as an observable because it allows you to display text
// outside of the UI stream.
// This is convenient to use in Flutter, React-Native integrations as well as in native projects
// to display a message simply by assigning a value to a variable.

public class Label {
    private static Label instance;

    private Label(String message) {
        this.message.set(message);
    }

    public static Label getInstance() {
        if (instance == null) {
            instance = new Label("");
        }
        return instance;
    }

    public ObservableField<String> message = new ObservableField<>();
}

