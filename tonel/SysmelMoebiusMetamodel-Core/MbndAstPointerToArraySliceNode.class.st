Class {
	#name : #MbndAstPointerToArraySliceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'pointer',
		'firstIndex',
		'lastIndex',
		'isOneBasedIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPointerToArraySliceNode >> accept: visitor [
	^ visitor visitPointerToArraySliceNode: self
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #initialization }
MbndAstPointerToArraySliceNode >> initialize [
	super initialize.
	isOneBasedIndex := false.
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> isOneBasedIndex [
	^ isOneBasedIndex
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> isOneBasedIndex: anObject [
	isOneBasedIndex := anObject
]

{ #category : #testing }
MbndAstPointerToArraySliceNode >> isPointerToArraySliceNode [
	^ true
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> lastIndex [
	^ lastIndex
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> lastIndex: anObject [
	lastIndex := anObject
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> pointer [
	^ pointer
]

{ #category : #accessing }
MbndAstPointerToArraySliceNode >> pointer: anObject [
	pointer := anObject
]
