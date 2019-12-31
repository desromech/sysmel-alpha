Class {
	#name : #MbndClassType,
	#superclass : #MbndAbstractClassType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndClassType class >> typeName [
	^ #_ClassType
]

{ #category : #visiting }
MbndClassType >> accept: aVisitor [
	^ aVisitor visitClassType: self
]

{ #category : #'testing methods' }
MbndClassType >> isClassType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndClassType >> unmangledStructureTypePrefix [
	^ 'class.'
]
