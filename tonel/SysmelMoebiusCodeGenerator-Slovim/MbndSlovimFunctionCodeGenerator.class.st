Class {
	#name : #MbndSlovimFunctionCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'ssaFunction',
		'concreteMethod',
		'slvmBuilder',
		'functionVariables'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> buildSSAFunction: aSSAFunction definitionWithConcreteMethod: aConcreteMethod [
	| entryBlock bodyBlock result |
	ssaFunction := aSSAFunction.
	concreteMethod := aConcreteMethod.
	functionVariables := Dictionary new.
	self assert: concreteMethod analyzedBody isNotNil.
	
	"Define the argument values."
	self defineArgumentValues.

	"Create the main slvm builder."	
	slvmBuilder := SLVMBuilder on: ssaFunction.
	entryBlock := slvmBuilder newBasicBlockHere: #entry.

	"Create the alloca builder."
	slvmBuilder allocaBuilder: ((SLVMBuilder on: ssaFunction)
		currentBlock: entryBlock).

	"Create the body block."	
	bodyBlock := slvmBuilder newBasicBlockHere: #body.
	
	"Generate the body code."
	result := self visitNode: concreteMethod analyzedBody.
	slvmBuilder currentBlock isLastTerminator ifTrue: [
		self assert: concreteMethod analyzedBody type isReturnType.
	] ifFalse: [ 
		self assert: concreteMethod analyzedBody type isReturnType not.
		
		concreteMethod returnType isVoidType ifTrue: [
			slvmBuilder returnVoid.
		] ifFalse: [
			slvmBuilder return: result
		]
	].

	"Jump from the alloca block into the body."
	slvmBuilder allocaBuilder jump: bodyBlock.
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionCodeGenerator >> defineArgumentValues [
	| argumentValue |
	self assert: concreteMethod arguments size = ssaFunction arguments size.
	concreteMethod arguments doWithIndex: [ :argVariable :argIndex |
		argumentValue := ssaFunction arguments at: argIndex.
		argVariable name isMbndAnonymousSymbol ifFalse: [
			argumentValue name: argVariable name
		].
	
		functionVariables at: argVariable put: argumentValue
	].

]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitFunctionCallNode: node [
	| functionValue argumentValues |
	functionValue := self visitNode: node function.
	argumentValues := self visitNodesAndCollect: node arguments.
	^ slvmBuilder call: functionValue arguments: argumentValues
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitLexicalScopeNode: node [
	^ self visitNode: node expression
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitLiteralValueNode: node [
	^ codeModuleGenerator translateLiteralValue: node value ofType: node type
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitMethodReferenceNode: node [
	^ (codeModuleGenerator translateProgramEntity: node binding) ssaValue
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitReturnStatementNode: node [
	| result |
	result := node expression ifNotNil: [ :expr | self visitNode: expr ].
	^ concreteMethod returnType isVoidType ifTrue: [
		slvmBuilder returnVoid
	] ifFalse: [
		self assert: result isNotNil.
		slvmBuilder return: result
	]
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitSequenceNode: node [
	| result |
	result := nil.
	node elements do: [ :element |
		result := self visitNode: element.
		slvmBuilder isLastTerminator ifTrue: [ ^ result ].
	].

	result ifNil: [ self halt ].
	^ result
]

{ #category : #visiting }
MbndSlovimFunctionCodeGenerator >> visitVariableReferenceNode: node [
	| binding |
	binding := node binding.
	functionVariables at: binding ifPresent: [ :ssaValue | ^ ssaValue ].
	^ (codeModuleGenerator translateProgramEntity: binding) ssaValue
]
