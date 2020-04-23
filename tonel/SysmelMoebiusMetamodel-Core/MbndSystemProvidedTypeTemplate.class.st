Class {
	#name : #MbndSystemProvidedTypeTemplate,
	#superclass : #MbndAbstractTemplate,
	#instVars : [
		'compilationTarget',
		'argumentNames',
		'instances',
		'mainDefinitionConstructionBlock'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #serialization }
MbndSystemProvidedTypeTemplate class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	| systemProvidedTypeTemplate |
	systemProvidedTypeTemplate := graphDecoder compilationTarget getBasicTypeNamed: earlyFields.
	graphDecoder registerObjectInstance: systemProvidedTypeTemplate; decodeNext.
	^ systemProvidedTypeTemplate
]

{ #category : #serialization }
MbndSystemProvidedTypeTemplate class >> messagePackTypeName [
	^ #SystemProvidedTypeTemplate
]

{ #category : #visiting }
MbndSystemProvidedTypeTemplate >> accept: aVisitor [
	^ aVisitor visitSystemProvidedTypeTemplate: self
]

{ #category : #'semantic analysis' }
MbndSystemProvidedTypeTemplate >> analyzeAndEvaluateApplicationNode: node withAnalyzer: analyzer [
	| argumentsNode arguments rawArguments result |
	argumentsNode := node arguments first.
	rawArguments := analyzer evaluateCompileTimeExpression: argumentsNode.
	self assert: rawArguments type isTupleType.
	
	arguments := rawArguments unwrapMbndValue.
	
	result := self getOrCreateInstanceWithArguments: arguments.
	^ result asLiteralValueNode
		position: node;
		yourself
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> argumentNames [
	^ argumentNames
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> argumentNames: anObject [
	argumentNames := anObject
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> compilationEnvironment [
	^ compilationTarget coreDefinitionsModule compilationEnvironment
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #serialization }
MbndSystemProvidedTypeTemplate >> encodeGraphForMessagePackWith: graphEncoder [
	self assert: name isNotNil.
	^ graphEncoder encodeObject: self type: self messagePackTypeName earlyFields: name fields: [ nil ]
]

{ #category : #template }
MbndSystemProvidedTypeTemplate >> getOrCreateInstanceWithArguments: arguments [
	^ instances at: arguments ifAbsent: [
		| newInstance |
		newInstance := mainDefinitionConstructionBlock valueWithArguments: arguments.
		self assert: (instances includesKey: arguments) not.
		instances at: arguments put: newInstance.
		
		MbndSystemProvidedTypeTemplateInstance new
			parent: self;
			instanceArguments: arguments;
			addChild: newInstance.
		
		definitionFragments do: [ :fragment | fragment applyToInstance: newInstance ].
		newInstance
	]
]

{ #category : #initialization }
MbndSystemProvidedTypeTemplate >> initialize [
	super initialize.
	instances := Dictionary new.
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> instances [
	^ instances
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> instances: anObject [
	instances := anObject
]

{ #category : #testing }
MbndSystemProvidedTypeTemplate >> isSystemProvidedTypeTemplate [
	^ true
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> mainDefinitionConstructionBlock [
	^ mainDefinitionConstructionBlock
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> mainDefinitionConstructionBlock: anObject [
	mainDefinitionConstructionBlock := anObject
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> type [
	^ self compilationTarget typeTemplateType
]
