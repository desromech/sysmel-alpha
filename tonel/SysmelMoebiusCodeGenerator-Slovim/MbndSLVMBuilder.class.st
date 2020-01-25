Class {
	#name : #MbndSLVMBuilder,
	#superclass : #SLVMBuilder,
	#instVars : [
		'currentUnwindBlock'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Utility'
}

{ #category : #accessing }
MbndSLVMBuilder >> currentUnwindBlock [
	^ currentUnwindBlock
]

{ #category : #accessing }
MbndSLVMBuilder >> currentUnwindBlock: anObject [
	currentUnwindBlock := anObject
]

{ #category : #accessing }
MbndSLVMBuilder >> newBasicBlock: name [
	| block |
	block := super newBasicBlock: name.
	block unwindBlock: currentUnwindBlock.
	^ block
]
