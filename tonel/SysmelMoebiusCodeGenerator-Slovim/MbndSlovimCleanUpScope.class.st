Class {
	#name : #MbndSlovimCleanUpScope,
	#superclass : #Object,
	#instVars : [
		'parent',
		'implicitFinalizationStateDictionary',
		'explicitFinalizationAction',
		'allowedNodesWithImplicitFinalization'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimCleanUpScope >> allowedNodesWithImplicitFinalization [
	^ allowedNodesWithImplicitFinalization
]

{ #category : #accessing }
MbndSlovimCleanUpScope >> allowedNodesWithImplicitFinalization: anObject [
	allowedNodesWithImplicitFinalization := anObject
]

{ #category : #accessing }
MbndSlovimCleanUpScope >> explicitFinalizationAction [
	^ explicitFinalizationAction
]

{ #category : #accessing }
MbndSlovimCleanUpScope >> explicitFinalizationAction: anObject [
	explicitFinalizationAction := anObject
]

{ #category : #accessing }
MbndSlovimCleanUpScope >> implicitFinalizationStateDictionary [
	^ implicitFinalizationStateDictionary
]

{ #category : #initialization }
MbndSlovimCleanUpScope >> initialize [
	super initialize.
	implicitFinalizationStateDictionary := OrderedDictionary new.
]

{ #category : #accessing }
MbndSlovimCleanUpScope >> parent [
	^ parent
]

{ #category : #accessing }
MbndSlovimCleanUpScope >> parent: anObject [
	parent := anObject
]
