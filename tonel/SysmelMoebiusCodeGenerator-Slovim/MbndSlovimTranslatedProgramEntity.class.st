Class {
	#name : #MbndSlovimTranslatedProgramEntity,
	#superclass : #Object,
	#instVars : [
		'programEntity'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedProgramEntity >> generateExpandedMessageSendNode: node with: codeGenerator [
	self subclassResponsibility
]

{ #category : #accessing }
MbndSlovimTranslatedProgramEntity >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndSlovimTranslatedProgramEntity >> programEntity: anObject [
	programEntity := anObject
]
