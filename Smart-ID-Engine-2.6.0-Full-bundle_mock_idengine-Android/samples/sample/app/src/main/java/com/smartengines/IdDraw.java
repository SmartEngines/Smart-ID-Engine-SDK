/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.smartengines.common.Quadrangle;
import com.smartengines.common.QuadranglesMapIterator;
import com.smartengines.id.IdResult;
import com.smartengines.id.IdTemplateSegmentationResult;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

public class IdDraw extends View {

  public static float scale = 1f;
  public static float translate_x = 0;
  public static float translate_y = 0;

  static class QuadStorage {
    private final float[] points = new float[16];

    QuadStorage(Quadrangle quad) {
      points[0] = (float) quad.GetPoint(0).getX() * scale;
      points[1] = (float) quad.GetPoint(0).getY() * scale;
      points[2] = (float) quad.GetPoint(1).getX() * scale;
      points[3] = (float) quad.GetPoint(1).getY() * scale;
      points[4] = (float) quad.GetPoint(1).getX() * scale;
      points[5] = (float) quad.GetPoint(1).getY() * scale;
      points[6] = (float) quad.GetPoint(2).getX() * scale;
      points[7] = (float) quad.GetPoint(2).getY() * scale;
      points[8] = (float) quad.GetPoint(2).getX() * scale;
      points[9] = (float) quad.GetPoint(2).getY() * scale;
      points[10] = (float) quad.GetPoint(3).getX() * scale;
      points[11] = (float) quad.GetPoint(3).getY() * scale;
      points[12] = (float) quad.GetPoint(3).getX() * scale;
      points[13] = (float) quad.GetPoint(3).getY() * scale;
      points[14] = (float) quad.GetPoint(0).getX() * scale;
      points[15] = (float) quad.GetPoint(0).getY() * scale;
    }

    public float[] getPoints() {
      return points;
    }
  }

  private final Paint paint = new Paint();

  private final int historyLength = 5;
  private final List<Set<QuadStorage>> quads = new LinkedList<>();

  public IdDraw(Context context) {
    super(context);
    initView();
  }

  public IdDraw(Context context, @Nullable AttributeSet attrs) {
    super(context, attrs);
    initView();
  }

  private void initView() {
    paint.setColor(Color.WHITE);
    paint.setStrokeWidth(3);
    paint.setAntiAlias(true);
  }

  public void showMatching(IdResult result) {
    if(result==null) return;;
    Set<QuadStorage> qs = new HashSet<>();

    for (int i = 0; i < result.GetTemplateDetectionResultsCount(); i++) {
      qs.add(new QuadStorage(result.GetTemplateDetectionResult(i).GetQuadrangle()));
    }

    for (int i = 0; i < result.GetTemplateSegmentationResultsCount(); i++) {
      IdTemplateSegmentationResult sg = result.GetTemplateSegmentationResult(i);

      for (QuadranglesMapIterator it = sg.RawFieldQuadranglesBegin();
           !it.Equals(sg.RawFieldQuadranglesEnd());
           it.Advance()) {
        qs.add(new QuadStorage(it.GetValue()));
      }
    }

    if (quads.size() == historyLength) {
      quads.remove(0);
    }

    quads.add(qs);
    postInvalidate();
  }

  public void cleanUp() {
    quads.clear();
    postInvalidate();
  }

  @Override
  protected void onDraw(@NonNull Canvas canvas) {
    super.onDraw(canvas);
    canvas.translate(translate_x * scale, translate_y * scale);
    int nq = quads.size();

    for (int i = 0; i < nq; i++) {
      int alfa = 255 * (i + 1) / nq;
      paint.setAlpha(alfa);

      for (QuadStorage q : quads.get(i)) {
        canvas.drawLines(q.getPoints(), paint);
      }
    }
  }

}

