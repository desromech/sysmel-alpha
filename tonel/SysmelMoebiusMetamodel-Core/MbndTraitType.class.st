Class {
	#name : #MbndTraitType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTraitType class >> typeName [
	^ #_TraitType
]

{ #category : #testing }
MbndTraitType >> isTrait [
	^ true
]

{ #category : #testing }
MbndTraitType >> isTraitType [
	^ true
]
