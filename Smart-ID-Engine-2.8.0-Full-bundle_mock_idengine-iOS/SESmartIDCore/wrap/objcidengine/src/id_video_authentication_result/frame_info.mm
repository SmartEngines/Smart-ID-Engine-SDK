/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_video_authentication_result.h>

#import <objcsecommon_impl/se_geometry_impl.h>
#import <objcsecommon_impl/se_image_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdVideoAuthenticationFrameInfoRef {
  se::id::IdVideoAuthenticationFrameInfo* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalVideoAuthenticationFrameInfoPointer:(se::id::IdVideoAuthenticationFrameInfo *)frame_info_ptr
                                               withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = frame_info_ptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdVideoAuthenticationFrameInfo *) getInternalVideoAuthenticationFrameInfoPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdVideoAuthenticationFrameInfo *) clone {
  return [[SEIdVideoAuthenticationFrameInfo alloc]
      initFromInternalVideoAuthenticationFrameInfo:(*ptr)];
}

- (int) getWidth {
  return ptr->GetWidth();
}

- (void) setWidthTo:(int)width {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetWidth(width);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getHeight {
  return ptr->GetHeight();
}

- (void) setHeightTo:(int)height {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetHeight(height);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getStride {
  return ptr->GetStride();
}

- (void) setStrideTo:(int)stride {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetStride(stride);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getChannels {
  return ptr->GetChannels();
}

- (void) setChannelsTo:(int)channels {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetChannels(channels);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SECommonSize *) getSize {
  return [[SECommonSize alloc] initFromInternalSize:ptr->GetSize()];
}

- (void) setSizeTo:(SECommonSize *)size {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetSize([size getInternalSize]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getTimestamp {
  return ptr->GetTimestamp();
}

- (void) setTimestampTo:(int)timestamp {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetTimestamp(timestamp);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

@end


@implementation SEIdVideoAuthenticationFrameInfo {
  std::unique_ptr<se::id::IdVideoAuthenticationFrameInfo> internal;
}

- (instancetype) initFromInternalVideoAuthenticationFrameInfo:(const se::id::IdVideoAuthenticationFrameInfo &)frame_info {
  if (self = [super init]) {
    internal.reset(new se::id::IdVideoAuthenticationFrameInfo(frame_info));
  }
  return self;
}

- (const se::id::IdVideoAuthenticationFrameInfo &) getInternalVideoAuthenticationFrameInfo {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdVideoAuthenticationFrameInfo);
  }
  return self;
}

- (instancetype) initFromImage:(SECommonImageRef *)image
                 withTimestamp:(int)timestamp {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdVideoAuthenticationFrameInfo(*[image getInternalImagePointer], timestamp));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdVideoAuthenticationFrameInfoRef *) getRef {
  return [[SEIdVideoAuthenticationFrameInfoRef alloc]
      initFromInternalVideoAuthenticationFrameInfoPointer:internal.get()
                                       withMutabilityFlag:NO];
}

- (SEIdVideoAuthenticationFrameInfoRef *) getMutableRef {
  return [[SEIdVideoAuthenticationFrameInfoRef alloc]
      initFromInternalVideoAuthenticationFrameInfoPointer:internal.get()
                                       withMutabilityFlag:YES];
}


@end
