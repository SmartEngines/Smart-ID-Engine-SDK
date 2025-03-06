/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_document_info_impl.h>
#import <objcsecommon_impl/se_strings_set_impl.h>

@implementation SEIdDocumentInfoRef {
  se::id::IdDocumentInfo* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalDocumentInfoPointer:(se::id::IdDocumentInfo *)infoptr 
                                  withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = infoptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdDocumentInfo *) getInternalDocumentInfoPointer {
  return ptr;
}

- (NSString *) getDocumentName {
  return [NSString stringWithUTF8String:ptr->GetDocumentName()];
}

- (NSString *) getDocumentDescription {
  return [NSString stringWithUTF8String:ptr->GetDocumentDescription()];
}

- (SECommonStringsSetRef *) getPradoLinks {
  return [[SECommonStringsSetRef alloc] 
      initFromInternalStringsSetPointer:const_cast<se::common::StringsSet*>(&ptr->GetPradoLinks())
                     withMutabilityFlag:NO];
}

- (SECommonStringsSetRef *) getDocumentTemplates {
  return [[SECommonStringsSetRef alloc] 
      initFromInternalStringsSetPointer:const_cast<se::common::StringsSet*>(&ptr->GetDocumentTemplates())
                     withMutabilityFlag:NO];
}

- (int) hasRFID {
  return ptr->HasRFID();
}

- (int) supportedRFID {
  return ptr->SupportedRFID();
}

@end
