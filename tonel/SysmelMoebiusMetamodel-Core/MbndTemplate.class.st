Class {
	#name : #MbndTemplate,
	#superclass : #MbndAbstractTemplate,
	#instVars : [
		'definitionPosition',
		'type',
		'instances',
		'mainDefinitionFragment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #serialization }
MbndTemplate class >> messagePackTypeName [
	^ #Template
]

{ #category : #visiting }
MbndTemplate >> accept: aVisitor [
	^ aVisitor visitTemplate: self
]

{ #category : #adding }
MbndTemplate >> addInstance: anInstance importedFromExternalModule: externalModule [
	| instanceArguments |
	instanceArguments := (anInstance instanceArguments collect: [ :each | each evaluatedValue unwrapMbndValue ]).
	instances at: instanceArguments ifAbsentPut: anInstance
]

{ #category : #template }
MbndTemplate >> createImmediateValue: argumentValue definitionType: definitionType [
	| actualArgumentType |
	actualArgumentType := argumentValue mbndLiteralTypeWithTarget: self compilationTarget.
	^ argumentValue asMoebiusValueWithType: actualArgumentType
]

{ #category : #accessing }
MbndTemplate >> definitionPosition [
	^ definitionPosition
]

{ #category : #accessing }
MbndTemplate >> definitionPosition: anObject [
	definitionPosition := anObject
]

{ #category : #serialization }
MbndTemplate >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name.
		#flags . flags.
		#type . self type encodeGraphForMessagePackWith: graphEncoder.
		#argumentTupleType . argumentTupleType encodeGraphForMessagePackWith: graphEncoder.
	} , (self isSealed ifFalse: [{
		#argumentDefinitions . argumentDefinitions collect: [:each | each encodeGraphForMessagePackWith: graphEncoder].
		#mainDefinitionFragment . mainDefinitionFragment encodeGraphForMessagePackWith: graphEncoder.
		#definitionFragments . definitionFragments collect: [ :each | each encodeGraphForMessagePackWith: graphEncoder ].
	}]), {
		#instances . (Array streamContents: [:out |
			instances keysAndValuesDo: [ :key :value |
				out nextPut: (key encodeGraphForMessagePackWith: graphEncoder);
					nextPut: (value encodeGraphForMessagePackWith: graphEncoder)
			]
		]) .
		#children . children encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #template }
MbndTemplate >> getExistingInstanceWithArguments:  arguments [
	^ instances at: arguments ifAbsent: [
		self error: 'Requested existing instance for template {1} with arguments {2} does not exist.'
			format: { self asString . arguments asString }
	].
]

{ #category : #template }
MbndTemplate >> getOrCreateInstanceWithArguments: arguments [
	| templateInstance mainDefinitionEvaluationResult |
	instances at: arguments ifPresent: [ :existent | ^ existent ].
	
	(self isSealed and: [ mainDefinitionFragment isNil ]) ifTrue: [
		^ self error: 'Cannot create new instances of sealed template {1} outside its definition module.' format: { self asString } 
	].
	
	"Create the template instance meta object."
	templateInstance := MbndTemplateInstance new
		module: self compilationEnvironment currentModule;
		instanceArguments: (arguments collectWithIndex: [ :argumentValue :index |
			| argDefinition |
			argDefinition := argumentDefinitions at: index.
			MbndCompileTimeConstant new
				name: argDefinition name;
				immediateValue: (self createImmediateValue: argumentValue definitionType: argDefinition valueType);
				yourself
			]);
		yourself.

	"Link the instance to the hierarchy."
	self addChild: templateInstance.
	instances at: arguments put: templateInstance.

	"Apply the main definition fragment."
	mainDefinitionEvaluationResult := mainDefinitionFragment applyToInstance: templateInstance.
	
	"If there is no main child node, then this must be a value template. In this case, replace the instance with the value."
	templateInstance mainChild ifNil: [
		instances at: arguments put: mainDefinitionEvaluationResult.
		^ mainDefinitionEvaluationResult
	].

	templateInstance module ~~ self module ifTrue: [
		templateInstance module recordTemplate: self instanceDefinition: templateInstance.
	].

	"Apply the extension fragments."
	definitionFragments do: [ :fragment | fragment applyToInstance: templateInstance ].

	^ templateInstance
]

{ #category : #accessing }
MbndTemplate >> inferTemplateKind [
	^ mainDefinitionFragment node inferTemplateKindWithCompilationTarget: self compilationTarget

]

{ #category : #initialization }
MbndTemplate >> initialize [
	super initialize.
	definitionPosition := MbndSourcePosition empty.
	instances := OrderedDictionary new.
	
]

{ #category : #testing }
MbndTemplate >> isSealed [
	^ self hasFlag: #sealed
]

{ #category : #accessing }
MbndTemplate >> mainDefinitionBody: node scope: scope [
	mainDefinitionFragment := MbndTemplateDefinitionFragment new
		node: node;
		scope: scope;
		yourself
]

{ #category : #serialization }
MbndTemplate >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	name := encodedFields at: #name ifAbsent: [ nil ].
	flags := encodedFields at: #flags.
	type := encodedFields at: #type.
	argumentTupleType := encodedFields at: #argumentTupleType.
	argumentDefinitions := encodedFields at: #argumentDefinitions ifAbsent: [nil].
	mainDefinitionFragment := encodedFields at: #mainDefinitionFragment ifAbsent: [nil].
	definitionFragments := (encodedFields at: #definitionFragments ifAbsent: [ #() ]) asOrderedCollection.
	
	instances := OrderedDictionary newFromPairs: (encodedFields at: #instances).
	children := encodedFields at: #children.

]

{ #category : #printing }
MbndTemplate >> printOn: aStream [
	aStream nextPutAll: 'template '; nextPutAll: self qualifiedName
]

{ #category : #accessing }
MbndTemplate >> type [
	^ type ifNil: [ type := self inferTemplateKind ]
]
