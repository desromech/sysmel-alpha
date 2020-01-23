Class {
	#name : #MbndSlovimFoldingLiteralGlobal,
	#superclass : #SLVMFakeValue,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #testing }
MbndSlovimFoldingLiteralGlobal >> isMbndSlovimFoldingLiteralGlobal [
	^ true
]

{ #category : #accessing }
MbndSlovimFoldingLiteralGlobal >> value [
	^ value
]

{ #category : #accessing }
MbndSlovimFoldingLiteralGlobal >> value: anObject [
	value := anObject
]
