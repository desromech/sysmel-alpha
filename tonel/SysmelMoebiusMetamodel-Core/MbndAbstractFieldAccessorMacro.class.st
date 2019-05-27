Class {
	#name : #MbndAbstractFieldAccessorMacro,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'field'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #accessing }
MbndAbstractFieldAccessorMacro >> field [
	^ field
]

{ #category : #accessing }
MbndAbstractFieldAccessorMacro >> field: anObject [
	field := anObject
]
