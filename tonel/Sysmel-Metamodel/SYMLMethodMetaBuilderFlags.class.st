Class {
	#name : #SYMLMethodMetaBuilderFlags,
	#superclass : #SYMLObject,
	#instVars : [
		'flags',
		'module',
		'parent'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLMethodMetaBuilderFlags class >> module: module parent: programEntity [
	^ self new
		module: module; 
		parent: programEntity;
		yourself
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> copyWithFlag: aFlag [
	^ self copy
		flags: ((flags copyWithout: aFlag) copyWith: aFlag);
		yourself
]

{ #category : #'method flags' }
SYMLMethodMetaBuilderFlags >> final [
	<compileTime>
	^ self copyWithFlag: #static
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> flags [
	^ flags
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> flags: anObject [
	flags := anObject
]

{ #category : #initialization }
SYMLMethodMetaBuilderFlags >> initialize [
	super initialize.
	flags := #().
	
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> message [
	<compileTime>
	^ SYMLMessageMethod new
			flags: flags;
			module: module;
			parent: parent;
			yourself
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> method [
	<compileTime>
	^ SYMLAPSGMetaObjectInstance new
			metaObject: (SYMLMethod new
				flags: flags;
				module: module;
				parent: parent);
			yourself
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> module [
	^ module
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> module: anObject [
	module := anObject
]

{ #category : #'method flags' }
SYMLMethodMetaBuilderFlags >> override [
	<compileTime>
	^ self copyWithFlag: #override
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> parent [
	^ parent
]

{ #category : #accessing }
SYMLMethodMetaBuilderFlags >> parent: anObject [
	parent := anObject
]

{ #category : #'method flags' }
SYMLMethodMetaBuilderFlags >> virtual [
	<compileTime>
	^ self copyWithFlag: #virtual
]
