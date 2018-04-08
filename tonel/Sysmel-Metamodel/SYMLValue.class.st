Class {
	#name : #SYMLValue,
	#superclass : #SYMLObject,
	#instVars : [
		'value',
		'type',
		'environment'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #'instance creation' }
SYMLValue class >> value: aValue type: aType [
	^ self new
		value: aValue;
		type: aType;
		yourself
]

{ #category : #comparing }
SYMLValue >> = other [
	^ self class == other class and:
	[ type == other type and: 
	[ value = other value ] ]
]

{ #category : #converting }
SYMLValue >> asAPSGNodeInEnvironment: newEnvironment at: aPosition [
	self isMetaObjectValue ifTrue: [ 
		^ SYMLAPSGMetaObjectInstance new
			position: aPosition;
			metaObject: value;
			yourself
	].
	^ SYMLAPSGLiteral new
		position: aPosition;
		value: self;
		yourself
]

{ #category : #converting }
SYMLValue >> asFunctionActivationValueAt: aPosition [
	self type isMetaObjectType ifTrue: [ 
		^ self value
	].

	self halt
]

{ #category : #'as yet unclassified' }
SYMLValue >> coercedIntoType: targetType at: coercionPosition. [
	^ type coerceValue: self into: targetType at: coercionPosition
]

{ #category : #'as yet unclassified' }
SYMLValue >> coercedWithRule: coercionRule intoType: targetType at: coercionPosition. [
	^ coercionRule convertValue: self into: targetType at: coercionPosition
]

{ #category : #'as yet unclassified' }
SYMLValue >> concretizeInEnvironment: concreteEnvironment [
	^ self
]

{ #category : #accessing }
SYMLValue >> environment [
	^ environment
]

{ #category : #accessing }
SYMLValue >> environment: anObject [
	environment := anObject
]

{ #category : #'meta evaluation' }
SYMLValue >> generateSSACodeWith: aBuilder [
	^ type generateSSAValue: value withBuilder: aBuilder
]

{ #category : #comparing }
SYMLValue >> hash [
	^ (self class identityHash bitXor: type identityHash) bitXor: value hash
]

{ #category : #testing }
SYMLValue >> isMetaObjectValue [
	^ type isMetaObjectType
]

{ #category : #testing }
SYMLValue >> isSysmelValue [
	^ true
]

{ #category : #printing }
SYMLValue >> printOn: aStream [
	^ aStream nextPutAll: self class name;
		nextPutAll: ' value: (';
		print: value;
		nextPutAll: ') type: (';
		print: type;
		nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
SYMLValue >> sysmelValueWithType: aType inEnvironment: anEnvironment [
	self halt
]

{ #category : #accessing }
SYMLValue >> type [
	^ type
]

{ #category : #accessing }
SYMLValue >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
SYMLValue >> unwrapSysmelValue [
	^ self value unwrapSysmelValue
]

{ #category : #accessing }
SYMLValue >> value [
	^ value
]

{ #category : #accessing }
SYMLValue >> value: anObject [
	value := anObject
]
