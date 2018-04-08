Class {
	#name : #SYMLMetaBuilder,
	#superclass : #SYMLObject,
	#instVars : [
		'metaObjectClass',
		'module',
		'parent'
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

{ #category : #'as yet unclassified' }
SYMLMetaBuilder class >> for: metaObjectClass module: module parent: parent [
	^ self new
		metaObjectClass: metaObjectClass;
		module: module;
		parent: parent;
		yourself
]

{ #category : #'as yet unclassified' }
SYMLMetaBuilder >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ SYMLAPSGMetaObjectInstance new
			position: identifier;
			metaObject: (self newInstanceInEnvironment: anEnvironment);
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
		parent: (parent ifNil: [anEnvironment definitionProgramEntity]);
		yourself
]

{ #category : #accessing }
SYMLMetaBuilder >> parent [
	^ parent
]

{ #category : #accessing }
SYMLMetaBuilder >> parent: anObject [
	parent := anObject
]
