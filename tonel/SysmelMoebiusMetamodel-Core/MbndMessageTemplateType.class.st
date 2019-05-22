Class {
	#name : #MbndMessageTemplateType,
	#superclass : #MbndTemplateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndMessageTemplateType class >> typeName [
	^ #_MessageTemplateType
]

{ #category : #testing }
MbndMessageTemplateType >> isMessageTemplateType [
	^ true
]
