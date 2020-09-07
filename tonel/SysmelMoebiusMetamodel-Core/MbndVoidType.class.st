Class {
	#name : #MbndVoidType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndVoidType class >> typeName [
	^ #Void
]

{ #category : #'type composition' }
MbndVoidType >> => returnType [
	<compileTime>
	^ self compilationTarget functionTypeWithArguments: #() returnType: returnType
]

{ #category : #visiting }
MbndVoidType >> accept: aVisitor [
	^ aVisitor visitVoidType: self
]

{ #category : #adding }
MbndVoidType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	
	self
		addConversionRule: (MbndConcretizeUndefinedTypeConversionRule when: [:source :target |
			source isReturnType not and:
			[target withoutTopDecorations isGarbageCollectedType and: [target withoutTopDecorations == self compilationTarget dynamicObjectType]]
	])

]

{ #category : #'default values' }
MbndVoidType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #sizes }
MbndVoidType >> instanceAlignment [
	<compileTime>
	^ 0
]

{ #category : #sizes }
MbndVoidType >> instanceSize [
	<compileTime>
	^ 0
]

{ #category : #testing }
MbndVoidType >> isTrait [
	^ false
]

{ #category : #testing }
MbndVoidType >> isVoidType [
	<compileTime>
	^ true
]
