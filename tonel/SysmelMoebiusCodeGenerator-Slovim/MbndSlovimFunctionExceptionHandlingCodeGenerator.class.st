Class {
	#name : #MbndSlovimFunctionExceptionHandlingCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'functionCodeGenerator',
		'implicitCleanUpActionStates',
		'allCleanUpScopes',
		'currentCleanUpScope',
		'inCleanUpContextCount'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> concreteMethod [
	^ functionCodeGenerator concreteMethod
]

{ #category : #'cleanup scopes' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> executeAllScopeCleanUpExceptForTokens: suppressedCleanUpTokens [
	| position |
	position := currentCleanUpScope.
	[ position ] whileNotNil: [
		self executeScopeCleanUpActions: position exceptForTokens: suppressedCleanUpTokens.
		self slvmBuilder isLastTerminator ifTrue: [ ^ self ] .
		position := position parent
	]
]

{ #category : #'cleanup scopes' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> executeImplicitFinalizationAction: action [
	| activated cleanUpBlock mergeBlock |
	action finalizationActionBlocks ifEmpty: [ ^ self ].
	action isActuallyExecuted: true.

	activated := self slvmBuilder load: action finalizationActivated.
	cleanUpBlock := self slvmBuilder newBasicBlock: #implicitCleanUpAction.
	mergeBlock := self slvmBuilder newBasicBlock: #implicitCleanUpMerge.

	self assert: self slvmBuilder currentBlock mergeBlock isNil.
	self slvmBuilder currentBlock mergeBlock: mergeBlock.
	self slvmBuilder branch: activated ifTrue: cleanUpBlock ifFalse: mergeBlock.
	
	self slvmBuilder currentBlock: cleanUpBlock.
	action finalizationActionBlocks do: [:each | each value].
	self slvmBuilder isLastTerminator ifFalse: [ self slvmBuilder jump: mergeBlock ].

	self slvmBuilder currentBlock: mergeBlock.
]

{ #category : #'cleanup scopes' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> executeScopeCleanUpActions: cleanUpScope [
	^ self executeScopeCleanUpActions: cleanUpScope exceptForTokens: #()
]

{ #category : #'cleanup scopes' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> executeScopeCleanUpActions: cleanUpScope exceptForTokens: suppressedCleanUpTokens [
	self subclassResponsibility
]

{ #category : #accessing }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> functionCodeGenerator [
	^ functionCodeGenerator
]

{ #category : #accessing }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> functionCodeGenerator: anObject [
	functionCodeGenerator := anObject.
	self codeModuleGenerator: functionCodeGenerator codeModuleGenerator.

]

{ #category : #visiting }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> generateCleanUpActionActivatedHereForNode: node token: token with: aBlock [
	| cleanUpActionState activatedFlag |
	self assert: currentCleanUpScope isNotNil.
	self assert: (currentCleanUpScope allowedNodesWithImplicitFinalization includes: node).
	cleanUpActionState := currentCleanUpScope implicitFinalizationStateDictionary at: token ifAbsentPut: [
		implicitCleanUpActionStates add: (MbndSlovimExceptionScopeImplicitFinalizationState new
			token: token;
			yourself)
	].
	
	cleanUpActionState finalizationActivated ifNil: [
		activatedFlag := self slvmBuilder allocaBuilder alloca: SLVMType boolType.
		cleanUpActionState finalizationActivated: activatedFlag.
		self slvmBuilder store: (self slvmBuilder constBool: true) in: activatedFlag.
	].
	cleanUpActionState addFinalizationActionBlock: aBlock.
]

{ #category : #'code generation' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> generateExceptionScopeNode: node [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> generateExceptionScopeNodeContent: node onCleanUpScope: cleanUpScope [
	| resultTemporary resultImplicitFinalization resultValue |
	resultTemporary := nil.
	resultImplicitFinalization := nil.
	self withExceptionScope: cleanUpScope do: [ 
		resultValue := self visitNode: node expression.
			
		(resultValue isNotNil and: [node type isVoidType not]) ifTrue: [ 
			"If the result value has an implicit finalization, we may be able to delay its finalization."
			cleanUpScope implicitFinalizationStateDictionary at: resultValue asCanonicalLocalReference ifPresent: [ :finalizationAction |
				resultImplicitFinalization := finalizationAction.
				cleanUpScope implicitFinalizationStateDictionary removeKey: finalizationAction token
			] ifAbsent: [
				node type hasTrivialFinalization ifFalse: [
					self assert: node type isMemoryReturnedType.
					resultTemporary := self  slvmBuilder allocaBuilder alloca: (self translateType: node type).
					functionCodeGenerator generateVariable: resultTemporary withValueType: node type initializationWithValue: resultValue initialValueKind: #move.
				].
			].
		].
	].

	currentCleanUpScope ifNotNil: [
		"Delay the implicit finalization of the result by lifting it up to the outer finalization scope."
		resultImplicitFinalization ifNotNil: [
			currentCleanUpScope implicitFinalizationStateDictionary at: resultImplicitFinalization token ifPresent: [ :previous |
				self error: 'Local variable with multiple finalization contexts.'
			] ifAbsentPut: [ resultImplicitFinalization ]
		].
	
		resultTemporary ifNotNil: [ 
			functionCodeGenerator addLocalVariable: resultTemporary withValueType: node type cleanUpActionForNode: node.
		].
	].

	"Set the initialized flags to false at the beginning of the clean-up scope."
	self initializeImplicitCleanUpFlagsInScope: cleanUpScope.
	^ resultValue
]

{ #category : #'code generation' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> generateUnwindingCode [
	self subclassResponsibility
]

{ #category : #testing }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> hasExceptions [
	^ true
]

{ #category : #'code generation' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> inCleanUpContextDo: aBlock [
	inCleanUpContextCount := inCleanUpContextCount + 1.
	aBlock ensure: [ inCleanUpContextCount := inCleanUpContextCount - 1 ]
]

{ #category : #initialization }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> initialize [
	super initialize.
	implicitCleanUpActionStates := OrderedCollection new.
	allCleanUpScopes := OrderedCollection new.
	inCleanUpContextCount := 0.
]

{ #category : #visiting }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> initializeImplicitCleanUpFlagsInScope: cleanUpScope [
	| falseConstant initializationInstructions |
	falseConstant := SLVMConstant bool: false.
	initializationInstructions := OrderedCollection new.
	cleanUpScope implicitFinalizationStateDictionary valuesDo: [ :implicitState |
		implicitState finalizationActivated ifNotNil: [ :var |
			initializationInstructions add: (SLVMStoreInstruction value: falseConstant variable: var)
		].
	].

	cleanUpScope scopeEntryBlock addInstructions: initializationInstructions after: nil.

]

{ #category : #accessing }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> nonLocalReturnContext [
	^ functionCodeGenerator nonLocalReturnContext
]

{ #category : #accessing }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> nonLocalReturnResultVariable [
	^ functionCodeGenerator nonLocalReturnResultVariable
]

{ #category : #'code generation' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> removeUnusedCleanUpActionStates [
	implicitCleanUpActionStates do: [ :cleanUpState |
		cleanUpState finalizationActivated ifNotNil: [ :activatedFlag |
			cleanUpState isActuallyExecuted ifFalse: [
				"Remove any reference to an unused clean-up action state."
				activatedFlag instructionReferences asArray do: [ :ref |
					self assert: ref isStore.
					ref removeFromBlock.
				].
				activatedFlag removeFromBlock
			].
		].
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> slvmBuilder [
	^ functionCodeGenerator slvmBuilder
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> ssaFunction [
	^ functionCodeGenerator ssaFunction
]

{ #category : #'visitor utilties' }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> visitNode: aNode [
	^ functionCodeGenerator visitNode: aNode
]

{ #category : #visiting }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> withExceptionScope: newCleanUpScope do: aBlock [
	| oldCleanUpScope |
	oldCleanUpScope := currentCleanUpScope.
	
	currentCleanUpScope := newCleanUpScope.
	^ aBlock ensure: [
		currentCleanUpScope := oldCleanUpScope.
	]
]

{ #category : #visiting }
MbndSlovimFunctionExceptionHandlingCodeGenerator >> withUnwindBlock: newUnwindBlock do: aBlock [
	| oldUnwindBlock |
	oldUnwindBlock := self slvmBuilder currentUnwindBlock.
	self slvmBuilder currentUnwindBlock: newUnwindBlock.
	aBlock ensure: [ self slvmBuilder currentUnwindBlock: oldUnwindBlock ]
]
