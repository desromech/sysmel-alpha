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

{ #category : #visiting }
MbndTemplate >> accept: aVisitor [
	^ aVisitor visitTemplate: self
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

{ #category : #template }
MbndTemplate >> getOrCreateInstanceWithArguments: arguments [
	| templateInstance mainDefinitionEvaluationResult |
	instances at: arguments ifPresent: [ :existent | ^ existent ].
	
	"Create the template instance meta object."
	templateInstance := MbndTemplateInstance new
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
	instances := WeakValueDictionary new.
	
]

{ #category : #accessing }
MbndTemplate >> mainDefinitionBody: node scope: scope [
	mainDefinitionFragment := MbndTemplateDefinitionFragment new
		node: node;
		scope: scope;
		yourself
]

{ #category : #accessing }
MbndTemplate >> type [
	^ type ifNil: [ type := self inferTemplateKind ]
]
