Class {
	#name : #MbndDecoratedType,
	#superclass : #MbndDerivedType,
	#instVars : [
		'decorations'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDecoratedType class >> typeName [
	^ #_DecoratedType
]

{ #category : #accessing }
MbndDecoratedType >> decorations [
	^ decorations
]

{ #category : #initialization }
MbndDecoratedType >> initialize [
	super initialize.
	decorations := #().
]
