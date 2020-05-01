"
I am a type that implements the following common functionality:
- Access to the definition module.
- Macro method dictionary.
- Macro method lookup.

"
Trait {
	#name : #TMbndType,
	#instVars : [
		'definitionModule',
		'subtypes',
		'explicitConversionRules',
		'implicitConversionRules'
	],
	#traits : 'TMbndAbstractType + TMbndMacroMethodContainer',
	#classTraits : 'TMbndAbstractType classTrait + TMbndMacroMethodContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
TMbndType >> addExplicitConversionRule: conversionRule [
	self explicitConversionRules add: conversionRule

]

{ #category : #adding }
TMbndType >> addImplicitConversionRule: conversionRule [
	self implicitConversionRules add: conversionRule

]

{ #category : #'semantic analysis' }
TMbndType >> analyzeInitializationFromCopyNode: node with: analyzer [
	self hasTrivialInitializationCopyingFrom ifTrue: [
		^ analyzer visitNode: (node asUnexpandedMessageSend
			selector: ((analyzer astBuilder literalSymbol: #assignValue:)
				position: node))
	].
	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #'as yet unclassified' }
TMbndType >> createMacroMethodEntityForPrototype: prototype defineInModule: moduleForDefinition [
	^ self createMacroMethodEntityForPrototype: prototype withReceiverType: self compilationTarget astNodeType defineInModule: moduleForDefinition
]

{ #category : #accessing }
TMbndType >> definitionModule: aModule [
	definitionModule := aModule
]

{ #category : #'as yet unclassified' }
TMbndType >> evaluatePendingDefinitionFragmentsForMacroSelector: aSelector [
	(self macroMethodDict includesKey: aSelector) ifTrue: [ ^ self ]. 
	self evaluatePendingDefinitionFragmentsForOverloadedSelector: aSelector

]

{ #category : #'as yet unclassified' }
TMbndType >> evaluatePendingDefinitionFragmentsForOverloadedSelector: aSelector [
	self overloadedMethodDict at: aSelector ifPresent: [ :found |
		found isMethodGroup ifFalse: [ ^ self ]
	].
	self evaluateAllPendingDefinitionFragments
]

{ #category : #accessing }
TMbndType >> explicitConversionRules [
	^ explicitConversionRules ifNil: [ explicitConversionRules := OrderedCollection new ]
]

{ #category : #testing }
TMbndType >> hasTrivialInitializationCopyingFrom [
	^ self hasTrivialInstanceInitializationCopyingFrom
]

{ #category : #accessing }
TMbndType >> implicitConversionRules [
	^ implicitConversionRules ifNil: [ implicitConversionRules := OrderedCollection new ]
]

{ #category : #testing }
TMbndType >> isPODInstance [
	^ self hasTrivialInstanceBasicInitialization and: [
	  self hasTrivialInstanceInitialization and: [
	  self hasTrivialInstanceFinalization and: [
	  self hasTrivialInstanceInitializationCopyingFrom and: [
	  self hasTrivialInstanceInitializationMovingFrom ]]]]
]

{ #category : #testing }
TMbndType >> isTrait [
	^ self hasFlag: #trait
]

{ #category : #'as yet unclassified' }
TMbndType >> lookupMacroSelector: aSelector [
	| macro |
	self evaluatePendingDefinitionFragmentsForMacroSelector: aSelector.
	macro := self macroMethodDict at: aSelector ifAbsent: [ nil ].
	macro ifNotNil: [ ^ macro ].
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #accessing }
TMbndType >> module [
	^ definitionModule
]

{ #category : #'as yet unclassified' }
TMbndType >> programEntitionInformationData [
	^ self programEntityInformationData
]

{ #category : #'type hierarchy' }
TMbndType >> subtypeAdded: aSubtype [
	self subtypes ifEmpty: [ subtypes := OrderedCollection new ].
	subtypes add: aSubtype.

]

{ #category : #'type hierarchy' }
TMbndType >> subtypeRemoved: aSubtype [
	^ subtypes := self subtypes copyWithout: aSubtype
]

{ #category : #accessing }
TMbndType >> subtypes [
	^ subtypes ifNil: [ subtypes := #() ]
]
