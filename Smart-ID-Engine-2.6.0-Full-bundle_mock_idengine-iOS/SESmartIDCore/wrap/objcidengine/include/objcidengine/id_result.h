/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_RESULT_H_INCLUDED
#define OBJCIDENGINE_ID_RESULT_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_fields.h>
#import <objcsecommon/se_common.h>

@class SEIdTemplateDetectionResult;

@interface SEIdTemplateDetectionResultRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdTemplateDetectionResult *) clone;

- (nonnull NSString *) getTemplateName;
- (void) setTemplateNameTo:(nonnull NSString *)name;

- (nonnull SECommonQuadrangle *) getQuadrangle;
- (void) setQuadrangleTo:(nonnull SECommonQuadrangle *)quadrangle;

- (BOOL) getIsAccepted;
- (void) setIsAcceptedTo:(BOOL)is_accepted;

- (double) getConfidence;
- (void) setConfidenceTo:(double)confidence;

- (nonnull SECommonSize *) getStandardSize;
- (void) setStandardSizeTo:(nonnull SECommonSize *)standard_size;

- (int) getAttributesCount;
- (nonnull NSString *) getAttributeWithName:(nonnull NSString *)attr_name;
- (BOOL) hasAttributeWithName:(nonnull NSString *)attr_name;
- (void) setAttributeWithName:(nonnull NSString *)attr_name
                           to:(nonnull NSString *)attr_value;
- (void) removeAttributeWithName:(nonnull NSString *)attr_name;

- (nonnull SECommonStringsMapIterator *) attributesBegin;
- (nonnull SECommonStringsMapIterator *) attributesEnd;

@end


@interface SEIdTemplateDetectionResult : NSObject

- (nonnull instancetype) initWithName:(nonnull NSString *)name 
                       withQuadrangle:(nonnull SECommonQuadrangle *)quadrangle
                       withConfidence:(double)confidence
                       withIsAccepted:(BOOL)is_accepted
                     withStandardSize:(nonnull SECommonSize *)standard_size;

- (nonnull SEIdTemplateDetectionResultRef *) getRef;
- (nonnull SEIdTemplateDetectionResultRef *) getMutableRef;

@end


@class SEIdTemplateSegmentationResult;

@interface SEIdTemplateSegmentationResultRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdTemplateSegmentationResult *) clone;

- (BOOL) getIsAccepted;
- (void) setIsAcceptedTo:(BOOL)is_accepted;

- (double) getConfidence;
- (void) setConfidenceTo:(double)confidence;

- (int) getRawFieldsCount;
- (BOOL) hasRawFieldWithName:(nonnull NSString *)raw_field_name;

- (nonnull SECommonQuadrangle *) getRawFieldQuadrangleWithName:(nonnull NSString *)raw_field_name;
- (nonnull SECommonQuadrangle *) getRawFieldTemplateQuadrangleWithName:(nonnull NSString *)raw_field_name;

- (void) setRawFieldQuadranglesForFieldWithName:(nonnull NSString *)raw_field_name
                                 withQuadrangle:(nonnull SECommonQuadrangle *)quadrangle
                         withTemplateQuadrangle:(nonnull SECommonQuadrangle *)template_quadrangle;

- (void) removeRawFieldWithName:(nonnull NSString *)raw_field_name;

- (nonnull SECommonQuadranglesMapIterator *) rawFieldQuadranglesBegin;
- (nonnull SECommonQuadranglesMapIterator *) rawFieldQuadranglesEnd;

- (nonnull SECommonQuadranglesMapIterator *) rawFieldTemplateQuadranglesBegin;
- (nonnull SECommonQuadranglesMapIterator *) rawFieldTemplateQuadranglesEnd;

@end


@interface SEIdTemplateSegmentationResult : NSObject

- (nonnull instancetype) initWithConfidence:(double)confidence
                             withIsAccepted:(BOOL)is_accepted;

- (nonnull SEIdTemplateSegmentationResultRef *) getRef;
- (nonnull SEIdTemplateSegmentationResultRef *) getMutableRef;

@end


@class SEIdResult;

@interface SEIdResultRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdResult *) clone;

- (nonnull NSString *) getDocumentType;
- (void) setDocumentTypeTo:(nonnull NSString *)document_type;

- (int) getTemplateDetectionResultsCount;
- (nonnull SEIdTemplateDetectionResultRef *) getTemplateDetectionResultAt:(int)index;
- (void) appendTemplateDetectionResult:(nonnull SEIdTemplateDetectionResultRef *)result;
- (void) clearTemplateDetectionResults;

- (int) getTemplateSegmentationResultsCount;
- (nonnull SEIdTemplateSegmentationResultRef *) getTemplateSegmentationResultAt:(int)index;
- (void) appendTemplateSegmentationResult:(nonnull SEIdTemplateSegmentationResultRef *)result;
- (void) clearTemplateSegmentationResults;

- (BOOL) getIsTerminal;
- (void) setIsTerminalTo:(BOOL)is_terminal;

- (nonnull SECommonStringsSetRef *) getSeenTemplates;
- (nonnull SECommonStringsSetRef *) getTerminalTemplates;

- (int) getTextFieldsCount;
- (BOOL) hasTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldRef *) getTextFieldWithName:(nonnull NSString *)field_name;
- (void) setTextFieldWithName:(nonnull NSString *)field_name
                           to:(nonnull SEIdTextFieldRef *)field;
- (void) removeTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldsMapIterator *) textFieldsBegin;
- (nonnull SEIdTextFieldsMapIterator *) textFieldsEnd;

- (int) getImageFieldsCount;
- (BOOL) hasImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldRef *) getImageFieldWithName:(nonnull NSString *)field_name;
- (void) setImageFieldWithName:(nonnull NSString *)field_name
                            to:(nonnull SEIdImageFieldRef *)field;
- (void) removeImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldsMapIterator *) imageFieldsBegin;
- (nonnull SEIdImageFieldsMapIterator *) imageFieldsEnd;

- (int) getAnimatedFieldsCount;
- (BOOL) hasAnimatedFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdAnimatedFieldRef *) getAnimatedFieldWithName:(nonnull NSString *)field_name;
- (void) setAnimatedFieldWithName:(nonnull NSString *)field_name
                               to:(nonnull SEIdAnimatedFieldRef *)field;
- (void) removeAnimatedFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdAnimatedFieldsMapIterator *) animatedFieldsBegin;
- (nonnull SEIdAnimatedFieldsMapIterator *) animatedFieldsEnd;

- (int) getCheckFieldsCount;
- (BOOL) hasCheckFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdCheckFieldRef *) getCheckFieldWithName:(nonnull NSString *)field_name;
- (void) setCheckFieldWithName:(nonnull NSString *)field_name
                            to:(nonnull SEIdCheckFieldRef *)field;
- (void) removeCheckFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdCheckFieldsMapIterator *) checkFieldsBegin;
- (nonnull SEIdCheckFieldsMapIterator *) checkFieldsEnd;

- (int) getForensicTextFieldsCount;
- (BOOL) hasForensicTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldRef *) getForensicTextFieldWithName:(nonnull NSString *)field_name;
- (void) setForensicTextFieldWithName:(nonnull NSString *)field_name
                                   to:(nonnull SEIdTextFieldRef *)field;
- (void) removeForensicTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldsMapIterator *) forensicTextFieldsBegin;
- (nonnull SEIdTextFieldsMapIterator *) forensicTextFieldsEnd;

- (int) getForensicImageFieldsCount;
- (BOOL) hasForensicImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldRef *) getForensicImageFieldWithName:(nonnull NSString *)field_name;
- (void) setForensicImageFieldWithName:(nonnull NSString *)field_name
                                    to:(nonnull SEIdImageFieldRef *)field;
- (void) removeForensicImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldsMapIterator *) forensicImageFieldsBegin;
- (nonnull SEIdImageFieldsMapIterator *) forensicImageFieldsEnd;

- (int) getForensicAnimatedFieldsCount;
- (BOOL) hasForensicAnimatedFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdAnimatedFieldRef *) getForensicAnimatedFieldWithName:(nonnull NSString *)field_name;
- (void) setForensicAnimatedFieldWithName:(nonnull NSString *)field_name
                                       to:(nonnull SEIdAnimatedFieldRef *)field;
- (void) removeForensicAnimatedFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdAnimatedFieldsMapIterator *) forensicAnimatedFieldsBegin;
- (nonnull SEIdAnimatedFieldsMapIterator *) forensicAnimatedFieldsEnd;

- (int) getForensicCheckFieldsCount;
- (BOOL) hasForensicCheckFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdCheckFieldRef *) getForensicCheckFieldWithName:(nonnull NSString *)field_name;
- (void) setForensicCheckFieldWithName:(nonnull NSString *)field_name
                                    to:(nonnull SEIdCheckFieldRef *)field;
- (void) removeForensicCheckFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdCheckFieldsMapIterator *) forensicCheckFieldsBegin;
- (nonnull SEIdCheckFieldsMapIterator *) forensicCheckFieldsEnd;


- (int) getRawTextFieldsCount;
- (BOOL) hasRawTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldRef *) getRawTextFieldWithName:(nonnull NSString *)field_name;
- (void) setRawTextFieldWithName:(nonnull NSString *)field_name
                              to:(nonnull SEIdTextFieldRef *)field;
- (void) removeRawTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldsMapIterator *) rawTextFieldsBegin;
- (nonnull SEIdTextFieldsMapIterator *) rawTextFieldsEnd;

- (int) getRawImageFieldsCount;
- (BOOL) hasRawImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldRef *) getRawImageFieldWithName:(nonnull NSString *)field_name;
- (void) setRawImageFieldWithName:(nonnull NSString *)field_name
                               to:(nonnull SEIdImageFieldRef *)field;
- (void) removeRawImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldsMapIterator *) rawImageFieldsBegin;
- (nonnull SEIdImageFieldsMapIterator *) rawImageFieldsEnd;

- (int) getCorrespondingRawFieldsCountForField:(nonnull NSString *)field_name;
- (BOOL) hasCorrespondingRawFieldForField:(nonnull NSString *)field_name
                         withRawFieldName:(nonnull NSString *)raw_field_name;

- (nonnull SECommonStringsSetIterator *) correspondingRawFieldNamesBeginForField:(nonnull NSString *)field_name;
- (nonnull SECommonStringsSetIterator *) correspondingRawFieldNamesEndForField:(nonnull NSString *)field_name;

- (int) getCorrespondingFieldsCountForRawField:(nonnull NSString *)raw_field_name;
- (BOOL) hasCorrespondingFieldForRawField:(nonnull NSString *)raw_field_name
                            withFieldName:(nonnull NSString *)field_name;

- (nonnull SECommonStringsSetIterator *) correspondingFieldNamesBeginForRawField:(nonnull NSString *)raw_field_name;
- (nonnull SECommonStringsSetIterator *) correspondingFieldNamesEndForRawField:(nonnull NSString *)raw_field_name;

@end

@interface SEIdResult : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithIsTerminal:(BOOL)is_terminal;

- (nonnull SEIdResultRef *) getRef;
- (nonnull SEIdResultRef *) getMutableRef;

@end

#endif // OBJCIDENGINE_ID_RESULT_H_INCLUDED
