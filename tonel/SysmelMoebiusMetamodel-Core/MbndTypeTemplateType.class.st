Class {
	#name : #MbndTypeTemplateType,
	#superclass : #MbndTemplateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTypeTemplateType class >> typeName [
	^ #_TypeTemplateType
]

{ #category : #testing }
MbndTypeTemplateType >> isTypeTemplateType [
	^ true
]
