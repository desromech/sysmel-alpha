Class {
	#name : #SYMLMetaBuilder,
	#superclass : #SYMLObject,
	#instVars : [
		'flags',
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
SYMLMetaBuilder >> analyzeAPSGIdentifierToMe: node inEnvironment: anEnvironment [
	^ SYMLAPSGMetaObjectInstance new
			position: node;
			metaObject: (self newInstanceInEnvironment: anEnvironment node: node);
			yourself
]

{ #category : #accessing }
SYMLMetaBuilder >> flags [
	^ flags
]

{ #category : #accessing }
SYMLMetaBuilder >> flags: anObject [
	flags := anObject
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
SYMLMetaBuilder >> newInstanceInEnvironment: anEnvironment node: node [
	^ metaObjectClass new
		module: module;
		definitionEnvironment: anEnvironment;
		definitionNode: node;
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
