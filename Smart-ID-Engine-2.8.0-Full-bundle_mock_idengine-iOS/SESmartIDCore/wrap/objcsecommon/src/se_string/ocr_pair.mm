/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcsecommon_impl/se_string_impl.h>
#import <objcsecommon_impl/se_serialization_impl.h>

#include <memory>

@implementation SECommonOcrPair {
  std::unique_ptr<se::common::OcrPair> internal;  
}

- (instancetype) initFromInternalOcrPair:(const se::common::OcrPair &)var {
  if (self = [super init]) {
    internal.reset(new se::common::OcrPair(var));
  }
  return self;
}

- (const se::common::OcrPair &) getInternalOcrPair {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::common::OcrPair);
  }
  return self;
}

- (instancetype) initWithChar:(NSString *)character 
                     withConf:(double)confidence {
  if (self = [super init]) {
    internal.reset(new se::common::OcrPair([character UTF8String], int(confidence)));
  }
  return self;
}

- (NSString *) getCharacter {
  return [NSString stringWithUTF8String:internal->GetCharacter()];
}

- (void) setCharacterTo:(NSString *)character {
  internal->SetCharacter([character UTF8String]);
}

- (int) getConfidence {
  return internal->GetConfidence();
}

- (void) setConfidence:(int)confidence {
  internal->SetConfidence(confidence);
}

- (void) serialize:(SECommonSerializer *)serializer {
//  internal->Serialize([serializer getInternalSerializer]);
}

@end
