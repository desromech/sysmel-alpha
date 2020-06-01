Class {
	#name : #MbndAbstractMethod,
	#superclass : #Object,
	#traits : 'TMbndMethod',
	#classTraits : 'TMbndMethod classTrait',
	#instVars : [
		'parent',
		'name'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAbstractMethod class >> messagePackTypeName [
	^ nil
]

{ #category : #'semantic analysis' }
MbndAbstractMethod >> analyzeExpandedMessageSendNode: node with: analyzer [
	self subclassResponsibility
]

{ #category : #'semantic analysis' }
MbndAbstractMethod >> analyzeReferenceNode: referenceNode with: analyzer [
	^ MbndAstMethodReference new
		binding: self;
		position: referenceNode;
		type: self type ref;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAbstractMethod >> assistBlockClosureNodeTypeInference: each asArgument: argumentIndex with: analyzer [
	^ each
]

{ #category : #evaluation }
MbndAbstractMethod >> canBeEvaluatedInCompileTime [
	(self hasPragmaNamed: #notInCompileTime) ifTrue: [ ^ false ].
	(self hasFlag: #notInCompileTime) ifTrue: [ ^ false ].
	^ true
]

{ #category : #serialization }
MbndAbstractMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MbndAbstractMethod >> ensureLookupSelectorIsRegisteredIn: programEntity [

]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateApplicationWithArguments: arguments withEvaluator: evaluator at: node [
	self assert: self receiverType isVoidType.
	^ self evaluateApplicationWithReceiver: nil arguments: arguments withEvaluator: evaluator at: node
]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateApplicationWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self subclassResponsibility
]

{ #category : #evaluation }
MbndAbstractMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self subclassResponsibility
]

{ #category : #'semantic analysis' }
MbndAbstractMethod >> hasExplicitSuperSend [
	^ self hasFlag: #hasExplicitSuperSend
]

{ #category : #testing }
MbndAbstractMethod >> hasPragmaNamed: pragmaName [
	^ self pragmaAt: pragmaName ifAbsent: [ false ] ifPresent: [ :x | true ]
]

{ #category : #testing }
MbndAbstractMethod >> hasVirtualTableEntry [
	^ false
]

{ #category : #'semantic analysis' }
MbndAbstractMethod >> markCompileTimeEvaluationImpossibility [
	self addFlag: #notInCompileTime.
]

{ #category : #'semantic analysis' }
MbndAbstractMethod >> markExplicitSuperSend [
	self addFlag: #hasExplicitSuperSend.
]

{ #category : #serialization }
MbndAbstractMethod >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #accessing }
MbndAbstractMethod >> module [
	^ parent module
]

{ #category : #accessing }
MbndAbstractMethod >> name [
	^ name
]

{ #category : #accessing }
MbndAbstractMethod >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
MbndAbstractMethod >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractMethod >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndAbstractMethod >> postMaterializeSetupParent: newParent withModule: newModule [
	self parent: newParent.
	self childrenDo: [ :child |
		child postMaterializeSetupParent: self withModule: newModule
	].
]

{ #category : #testing }
MbndAbstractMethod >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ absentBlock value
]

{ #category : #testing }
MbndAbstractMethod >> pragmaAt: pragmaName ifPresent: presentBlock [
	^ self pragmaAt: pragmaName ifAbsent: [nil] ifPresent: presentBlock
]

{ #category : #asserting }
MbndAbstractMethod >> shouldMangleReturnType [
	^ false
]

{ #category : #'as yet unclassified' }
MbndAbstractMethod >> typedSelector [
	^ name
]
