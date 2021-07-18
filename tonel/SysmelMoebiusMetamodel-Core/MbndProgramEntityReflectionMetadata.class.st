Class {
	#name : #MbndProgramEntityReflectionMetadata,
	#superclass : #Object,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#instVars : [
		'wrapped'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #visiting }
MbndProgramEntityReflectionMetadata >> accept: aModuleVisitor [
	^ aModuleVisitor visitProgramEntityReflectionMetadata: self
]

{ #category : #testing }
MbndProgramEntityReflectionMetadata >> isProgramEntityReflectionMetadata [
	^ true
]

{ #category : #testing }
MbndProgramEntityReflectionMetadata >> module [
	^ wrapped module
]

{ #category : #accessing }
MbndProgramEntityReflectionMetadata >> wrapped [

	^ wrapped
]

{ #category : #accessing }
MbndProgramEntityReflectionMetadata >> wrapped: anObject [

	wrapped := anObject
]
