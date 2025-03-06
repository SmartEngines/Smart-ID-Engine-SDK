/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FIELDS_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FIELDS_H_INCLUDED

#import <objcidengine/id_fields.h>

#include <idengine/id_fields.h>

se::id::IdCheckStatus status_e2i(SEIdCheckStatus s);
SEIdCheckStatus status_i2e(se::id::IdCheckStatus s);

@interface SEIdBaseFieldInfoRef (Internal)

- (instancetype) initFromInternalBaseFieldInfoPointer:(se::id::IdBaseFieldInfo *)infoptr
                                   withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdBaseFieldInfo *) getInternalBaseFieldInfoPointer;

@end


@interface SEIdBaseFieldInfo (Internal)

- (instancetype) initFromInternalBaseFieldInfo:(const se::id::IdBaseFieldInfo &)info;
- (const se::id::IdBaseFieldInfo &) getInternalBaseFieldInfo;

@end


@interface SEIdTextFieldRef (Internal)

- (instancetype) initFromInternalTextFieldPointer:(se::id::IdTextField *)fieldptr
                               withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdTextField *) getInternalTextFieldPointer;

@end


@interface SEIdTextField (Internal)

- (instancetype) initFromInternalTextField:(const se::id::IdTextField &)field;
- (const se::id::IdTextField &) getInternalTextField;

@end


@interface SEIdTextFieldsMapIterator (Internal)

- (instancetype) initFromInternalTextFieldsMapIterator:(const se::id::IdTextFieldsMapIterator &)iter;
- (const se::id::IdTextFieldsMapIterator &) getInternalTextFieldsMapIterator;

@end


@interface SEIdImageFieldRef (Internal)

- (instancetype) initFromInternalImageFieldPointer:(se::id::IdImageField *)fieldptr
                                withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdImageField *) getInternalImageFieldPointer;

@end


@interface SEIdImageField (Internal)

- (instancetype) initFromInternalImageField:(const se::id::IdImageField &)field;
- (const se::id::IdImageField &) getInternalImageField;

@end


@interface SEIdImageFieldsMapIterator (Internal)

- (instancetype) initFromInternalImageFieldsMapIterator:(const se::id::IdImageFieldsMapIterator &)iter;
- (const se::id::IdImageFieldsMapIterator &) getInternalImageFieldsMapIterator;

@end


@interface SEIdAnimatedFieldRef (Internal)

- (instancetype) initFromInternalAnimatedFieldPointer:(se::id::IdAnimatedField *)fieldptr
                                   withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdAnimatedField *) getInternalAnimatedFieldPointer;

@end


@interface SEIdAnimatedField (Internal)

- (instancetype) initFromInternalAnimatedField:(const se::id::IdAnimatedField &)field;
- (const se::id::IdAnimatedField &) getInternalAnimatedField;

@end


@interface SEIdAnimatedFieldsMapIterator (Internal)

- (instancetype) initFromInternalAnimatedFieldsMapIterator:(const se::id::IdAnimatedFieldsMapIterator &)iter;
- (const se::id::IdAnimatedFieldsMapIterator &) getInternalAnimatedFieldsMapIterator;

@end


@interface SEIdCheckFieldRef (Internal)

- (instancetype) initFromInternalCheckFieldPointer:(se::id::IdCheckField *)fieldptr
                                withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdCheckField *) getInternalCheckFieldPointer;

@end


@interface SEIdCheckField (Internal)

- (instancetype) initFromInternalCheckField:(const se::id::IdCheckField &)field;
- (const se::id::IdCheckField &) getInternalCheckField;

@end


@interface SEIdCheckFieldsMapIterator (Internal)

- (instancetype) initFromInternalCheckFieldsMapIterator:(const se::id::IdCheckFieldsMapIterator &)iter;
- (const se::id::IdCheckFieldsMapIterator &) getInternalCheckFieldsMapIterator;

@end

#endif // OBJCIDENGINE_IMPL_ID_FIELDS_H_INCLUDED