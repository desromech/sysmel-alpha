Class {
	#name : #MbndSlovimDescriptorSetReference,
	#superclass : #SLVMFakeValue,
	#instVars : [
		'setIndex',
		'valueType'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #testing }
MbndSlovimDescriptorSetReference >> isMbndDescriptorSetReference [
	^ true
]

{ #category : #accessing }
MbndSlovimDescriptorSetReference >> setIndex [
	^ setIndex
]

{ #category : #accessing }
MbndSlovimDescriptorSetReference >> setIndex: anObject [
	setIndex := anObject
]

{ #category : #accessing }
MbndSlovimDescriptorSetReference >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndSlovimDescriptorSetReference >> valueType: anObject [
	valueType := anObject
]
