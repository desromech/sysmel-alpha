Class {
	#name : #SYMLAPSGArgumentDefinition,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'name',
		'typeExpression',
		'type'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> name [
	^ name
]

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> semanticAnalysisInEnvironment: environment [
	| analyzedType variable |
	type ifNotNil: [ ^ self ].

	analyzedType := type.
	typeExpression ifNotNil: [ 
		analyzedType := (typeExpression analyzeAndEvaluateInEnvironment: environment) unwrapSysmelValue.
	].

	analyzedType ifNil: [
		self error: 'A type specification is required for argument {1}.' format: { name } at: self
	].

	variable := SYMLFunctionClosureArgument new
		definitionEnvironment: environment;
		definitionNode: self;
		name: name;
		type: analyzedType;
		yourself.
	environment addClosureArgumentVariable: variable at: position.
	^ variable
]

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> type [
	^ type
]

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> type: anObject [
	type := anObject
]

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> typeExpression [
	^ typeExpression
]

{ #category : #accessing }
SYMLAPSGArgumentDefinition >> typeExpression: anObject [
	typeExpression := anObject
]
