/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcsecommon_impl/se_geometry_impl.h>

#include <memory>

@implementation SECommonQuadranglesVectorIterator {
  std::unique_ptr<se::common::QuadranglesVectorIterator> internal;
}

- (instancetype) initFromInternalQuadranglesVectorIterator:(const se::common::QuadranglesVectorIterator &)iter {
  if (self = [super init]) {
    internal.reset(new se::common::QuadranglesVectorIterator(iter));
  }
  return self;
}

- (const se::common::QuadranglesVectorIterator &) getInternalQuadranglesVectorIterator {
  return *internal;
}

- (instancetype) initWithOther:(SECommonQuadranglesVectorIterator *)other {
  if (self = [super init]) {
    internal.reset(new se::common::QuadranglesVectorIterator([other getInternalQuadranglesVectorIterator]));
  }
  return self;
}

- (BOOL) isEqualToIter:(SECommonQuadranglesVectorIterator *)other {
  return internal->Equals([other getInternalQuadranglesVectorIterator])? YES : NO;
}

- (SECommonQuadrangle *) getValue {
  return [[SECommonQuadrangle alloc] initFromInternalQuadrangle:internal->GetValue()];
}

- (void) advance {
  internal->Advance();
}

@end
