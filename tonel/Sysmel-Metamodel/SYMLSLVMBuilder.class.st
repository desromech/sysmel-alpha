Class {
	#name : #SYMLSLVMBuilder,
	#superclass : #SLVMBuilder,
	#instVars : [
		'breakBlock',
		'continueBlock'
	],
	#category : #Sysmel-Metamodel-CodeGeneration
}

{ #category : #accessing }
SYMLSLVMBuilder >> breakBlock [
	^ breakBlock
]

{ #category : #accessing }
SYMLSLVMBuilder >> breakBlock: anObject [
	breakBlock := anObject
]

{ #category : #accessing }
SYMLSLVMBuilder >> continueBlock [
	^ continueBlock
]

{ #category : #accessing }
SYMLSLVMBuilder >> continueBlock: anObject [
	continueBlock := anObject
]

{ #category : #'as yet unclassified' }
SYMLSLVMBuilder >> withBreak: newBreakBlock continue: newContinueBlock do: action [
	| oldBreak oldContinue |
	oldBreak := breakBlock.
	oldContinue := continueBlock.
	breakBlock := newBreakBlock.
	continueBlock := newContinueBlock.
	action ensure: [
		breakBlock := oldBreak.
		continueBlock := oldContinue.
	]
]
