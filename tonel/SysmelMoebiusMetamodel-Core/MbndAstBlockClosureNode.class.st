Class {
	#name : #MbndAstBlockClosureNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'isBlockWithNonLocalReturn',
		'arguments',
		'returnType',
		'body',
		'blockClosureProgramEntity',
		'closureKind'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBlockClosureNode >> accept: aVisitor [
	^ aVisitor visitBlockClosureNode: self
]

{ #category : #accessing }
MbndAstBlockClosureNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstBlockClosureNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
MbndAstBlockClosureNode >> asFunctionDefinitionNode [
	| prototype |
	prototype := MbndAstFunctionPrototypeNode new
		position: self;
		arguments: arguments;
		returnType: returnType;
		yourself.
	^ MbndAstFunctionDefinitionNode new
		position: self;
		prototype: prototype;
		body: body;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstBlockClosureNode >> assistTypeInferenceWithDefaultArgumentType: defaultArgumentType returnType: defaultReturnType with: analyzer [
	| newArguments |
	newArguments := (arguments allSatisfy: [:each | each valueType isNotNil])
		ifTrue: [arguments]
		ifFalse: [arguments collect: [:each | each valueType
					ifNil: [ each copy valueType: defaultArgumentType]
					ifNotNil: [each]]].
	(newArguments == arguments and: [ returnType isNotNil ]) ifTrue: [ ^ self ].
	
	^ self copy
		arguments: newArguments;
		returnType: (returnType ifNil: [defaultReturnType]);
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstBlockClosureNode >> assistTypeInferenceWithExpectedType: expectedType with: analyzer [
	"We catch the compilation time error in a later stage."
	| newArguments |
	expectedType isBlockClosureType ifFalse: [ ^ self ].
	expectedType argumentTypes size = arguments size ifFalse: [ ^ self ].
	
	newArguments := (arguments allSatisfy: [:each | each valueType isNotNil])
		ifTrue: [arguments]
		ifFalse: [arguments collectWithIndex: [:each :index | each valueType
					ifNil: [ each copy valueType: (expectedType argumentTypes at: index)]
					ifNotNil: [each]]].
	(newArguments == arguments and: [ returnType isNotNil and: [closureKind isNotNil]]) ifTrue: [ ^ self ].
	
	^ self copy
		arguments: newArguments;
		returnType: (returnType ifNil: [ expectedType returnType ]);
		closureKind: (closureKind ifNil: [ expectedType closureKind]);
		yourself
]

{ #category : #accessing }
MbndAstBlockClosureNode >> blockClosureProgramEntity [
	^ blockClosureProgramEntity
]

{ #category : #accessing }
MbndAstBlockClosureNode >> blockClosureProgramEntity: anObject [
	blockClosureProgramEntity := anObject
]

{ #category : #accessing }
MbndAstBlockClosureNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstBlockClosureNode >> body: anObject [
	body := anObject
]

{ #category : #accessing }
MbndAstBlockClosureNode >> closureKind [
	^ closureKind
]

{ #category : #accessing }
MbndAstBlockClosureNode >> closureKind: anObject [
	closureKind := anObject
]

{ #category : #serialization }
MbndAstBlockClosureNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#isBlockWithNonLocalReturn . isBlockWithNonLocalReturn.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#returnType . returnType encodeGraphForMessagePackWith: graphEncoder.
		#closureKind . closureKind encodeGraphForMessagePackWith: graphEncoder.
		#body . body encodeGraphForMessagePackWith: graphEncoder.
		#blockClosureProgramEntity . blockClosureProgramEntity encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #initialization }
MbndAstBlockClosureNode >> initialize [
	super initialize.
	isBlockWithNonLocalReturn := true.
]

{ #category : #'as yet unclassified' }
MbndAstBlockClosureNode >> isBlockClosureNode [
	^ true
]

{ #category : #testing }
MbndAstBlockClosureNode >> isBlockClosureWithImmediateActivation [
	^ blockClosureProgramEntity isBlockClosureWithImmediateActivation
]

{ #category : #accessing }
MbndAstBlockClosureNode >> isBlockWithNonLocalReturn [
	^ isBlockWithNonLocalReturn
]

{ #category : #accessing }
MbndAstBlockClosureNode >> isBlockWithNonLocalReturn: anObject [
	isBlockWithNonLocalReturn := anObject
]

{ #category : #serialization }
MbndAstBlockClosureNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	isBlockWithNonLocalReturn := encodedFields at: #isBlockWithNonLocalReturn.
	arguments := encodedFields at: #arguments.
	returnType := encodedFields at: #returnType.
	closureKind := encodedFields at: #closureKind.
	body := encodedFields at: #body.
	blockClosureProgramEntity := encodedFields at: #blockClosureProgramEntity.
]

{ #category : #accessing }
MbndAstBlockClosureNode >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndAstBlockClosureNode >> returnType: anObject [
	returnType := anObject
]
