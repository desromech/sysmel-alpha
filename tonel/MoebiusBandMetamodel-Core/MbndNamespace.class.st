Class {
	#name : #MbndNamespace,
	#superclass : #MbndAbstractNamespace,
	#traits : 'TMbndNamespace',
	#classTraits : 'TMbndNamespace classTrait',
	#instVars : [
		'name',
		'module'
	],
	#category : #'MoebiusBandMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
MbndNamespace >> module [
	^ module
]

{ #category : #accessing }
MbndNamespace >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndNamespace >> name [
	^ name
]

{ #category : #accessing }
MbndNamespace >> name: anObject [
	name := anObject
]
