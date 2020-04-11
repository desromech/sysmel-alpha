Class {
	#name : #MbndCompileTimeConstant,
	#superclass : #MbndAbstractCompileTimeConstant,
	#traits : 'TMbndFlagContainer + TMbndEntityWithVisibility',
	#classTraits : 'TMbndFlagContainer classTrait + TMbndEntityWithVisibility classTrait',
	#instVars : [
		'name',
		'parent',
		'valueNode',
		'valueScope',
		'evaluatedValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant class >> messagePackTypeName [
	^ #CompileTimeConstant
]

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> accept: aVisitor [
	^ aVisitor visitCompileTimeConstant: self
]

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> analyzeReferenceNode: referenceNode with: analyzer [
	self ensureSemanticAnalysis.
	^ evaluatedValue asLiteralValueNode
]

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> attemptToSetTemplateInstanceMainAliasTo: value [
	value isMbndProgramEntity ifFalse: [ ^ self ].
	value parent ifNil: [ ^ self ].
	value parent isTemplateInstance ifFalse: [ ^ self ].
	value parent attemptToSetMainAliasTo: self
]

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> compilationEnvironment [
	^ parent compilationEnvironment
]

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> compilationTarget [
	^ parent compilationTarget
]

{ #category : #accessing }
MbndCompileTimeConstant >> defaultVisibilityMode [
	^ #public
]

{ #category : #serialization }
MbndCompileTimeConstant >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name.
		#value . evaluatedValue encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #'semantic analysis' }
MbndCompileTimeConstant >> ensureSemanticAnalysis [
	(self hasFlag: #evaluating) ifTrue: [
		self error: 'Compile time constant {1} has a recursive definition.' format: { name asPrettySymbolName } at: valueNode
	].

	evaluatedValue ifNotNil: [
		^ self
	].

	self addFlag: #evaluating.
	evaluatedValue := MbndAstSemanticAnalyzer new 
		module: self module;
		scope: valueScope;
		evaluateCompileTimeExpression: valueNode.
		
	self attemptToSetTemplateInstanceMainAliasTo: evaluatedValue value.

	self removeFlag: #evaluating.
]

{ #category : #accessing }
MbndCompileTimeConstant >> evaluatedValue [
	self ensureSemanticAnalysis.
	^ evaluatedValue
]

{ #category : #accessing }
MbndCompileTimeConstant >> immediateValue: aValue [
	evaluatedValue := aValue
]

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> isCompileTimeConstant [
	^ true
]

{ #category : #serialization }
MbndCompileTimeConstant >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	name := encodedFields at: #name ifAbsent: [ nil ].
	evaluatedValue := encodedFields at: #value.
]

{ #category : #accessing }
MbndCompileTimeConstant >> module [
	^ parent module
]

{ #category : #accessing }
MbndCompileTimeConstant >> name [
	^ name
]

{ #category : #accessing }
MbndCompileTimeConstant >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
MbndCompileTimeConstant >> parent [
	^ parent
]

{ #category : #accessing }
MbndCompileTimeConstant >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndCompileTimeConstant >> postMaterializeSetupParent: newParent withModule: newModule [
	self parent: newParent.
]

{ #category : #printing }
MbndCompileTimeConstant >> printOn: aStream [
	aStream nextPutAll: 'compileTimeConstant '; nextPutAll: self qualifiedName asPrettySymbolName
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueNode [
	^ valueNode
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueNode: anObject [
	valueNode := anObject
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueScope [
	^ valueScope
]

{ #category : #accessing }
MbndCompileTimeConstant >> valueScope: anObject [
	valueScope := anObject
]
