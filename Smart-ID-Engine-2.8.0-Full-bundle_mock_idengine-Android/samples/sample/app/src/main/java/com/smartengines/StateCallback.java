/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import com.smartengines.id.IdResult;

public interface StateCallback {
  void initialized(boolean engine_initialized);
  void recognized(IdResult result);
  void started();
  void stopped();
  void error(String message);
}
