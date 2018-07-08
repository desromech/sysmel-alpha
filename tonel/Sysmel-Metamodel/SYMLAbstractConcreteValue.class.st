Class {
	#name : #SYMLAbstractConcreteValue,
	#superclass : #SYMLAbstractValue,
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #converting }
SYMLAbstractConcreteValue >> asAPSGNodeInEnvironment: newEnvironment at: aPosition [
	(self value isNotNil and: [self isMetaObjectValue]) ifTrue: [ 
		^ self value asAPSGNodeInEnvironment: newEnvironment at: aPosition
	].
	^ SYMLAPSGLiteral new
		position: aPosition;
		value: (self asSysmelValueInEnvironment: newEnvironment);
		yourself
]

{ #category : #converting }
SYMLAbstractConcreteValue >> asIncompleteValue [
	^ self
]

{ #category : #converting }
SYMLAbstractConcreteValue >> asSysmelValueInEnvironment: anEnvironment [
	^ self value sysmelValueWithType: self type inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLAbstractConcreteValue >> coercedIntoType: targetType at: coercionPosition [
	^ self type coerceValue: self into: targetType at: coercionPosition
]

{ #category : #'as yet unclassified' }
SYMLAbstractConcreteValue >> coercedWithRule: coercionRule intoType: targetType at: coercionPosition. [
	^ coercionRule convertValue: self into: targetType at: coercionPosition
]

{ #category : #'pattern matching' }
SYMLAbstractConcreteValue >> matchValue: suppliedValue withMatchingContext: patternMatchingContext at: position [
	^ suppliedValue value = self value ifTrue: [ suppliedValue ] ifFalse: [ nil ]
]

{ #category : #accessing }
SYMLAbstractConcreteValue >> sysmelMangledValue [
	<compileTime>
	^ self value sysmelMangledValue
]

{ #category : #evaluating }
SYMLAbstractConcreteValue >> value [
	self subclassResponsibility
]
