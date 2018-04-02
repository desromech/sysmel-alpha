Class {
	#name : #SYMLMetaBuilder,
	#superclass : #SYMLObject,
	#instVars : [
		'metaObjectClass',
		'module'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLMetaBuilder class >> for: metaObjectClass module: module [
	^ self new
		metaObjectClass: metaObjectClass;
		module: module;
		yourself
]

{ #category : #testing }
SYMLMetaBuilder >> isMetaBuilder [
	^ true
]

{ #category : #accessing }
SYMLMetaBuilder >> metaObjectClass [
	^ metaObjectClass
]

{ #category : #accessing }
SYMLMetaBuilder >> metaObjectClass: anObject [
	metaObjectClass := anObject
]

{ #category : #accessing }
SYMLMetaBuilder >> module [
	^ module
]

{ #category : #accessing }
SYMLMetaBuilder >> module: anObject [
	module := anObject
]

{ #category : #'instance creation' }
SYMLMetaBuilder >> newInstanceInEnvironment: anEnvironment [
	^ metaObjectClass new
		module: module;
		definitionEnvironment: anEnvironment;
		parent: anEnvironment definitionProgramEntity;
		yourself
]
