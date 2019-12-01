Class {
	#name : #MbndSlovimLoadedReferenceValue,
	#superclass : #SLVMFakeValue,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #testing }
MbndSlovimLoadedReferenceValue >> isMbndLoadedReferenceValue [
	^ true
]

{ #category : #accessing }
MbndSlovimLoadedReferenceValue >> value [
	^ value
]

{ #category : #accessing }
MbndSlovimLoadedReferenceValue >> value: anObject [
	value := anObject
]
