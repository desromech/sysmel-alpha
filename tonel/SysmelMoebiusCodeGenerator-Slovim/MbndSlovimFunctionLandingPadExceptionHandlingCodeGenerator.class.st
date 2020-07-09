Class {
	#name : #MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator,
	#superclass : #MbndSlovimFunctionExceptionHandlingCodeGenerator,
	#instVars : [
		'forbiddenExceptionDuringCleanupTarget',
		'unwindExceptionPointerVariable',
		'unwindExceptionSelectorVariable'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> forbiddenExceptionDuringCleanupTarget [
	^ forbiddenExceptionDuringCleanupTarget
]

{ #category : #visiting }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateForbiddenExceptionDuringCleanupTarget [
	| builder landingPath exceptionPointer |
	forbiddenExceptionDuringCleanupTarget ifNil: [ ^ self ].
	builder := SLVMBuilder on: self ssaFunction.
	builder currentBlock: forbiddenExceptionDuringCleanupTarget.
	self isEmittingDebugInformation ifTrue: [ 
		builder pushDebugSourcePosition: (codeModuleGenerator convertDebugPosition: self concreteMethod definitionPosition asActualSourcePosition scope: nil)
	].

	landingPath := builder landingPath: codeModuleGenerator landingPathResultType.
	landingPath catchedExceptions: {SLVMConstant nullPointer: self slvmCompilationTarget voidPointerType}.
	
	exceptionPointer := builder extractValue: landingPath indices: #(0).
	builder call: (codeModuleGenerator forbiddenExceptionHandlingFunction) arguments: { exceptionPointer }.
	builder unreachable.

]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingCatchSelectionFor: exceptionScope [
	self assert: exceptionScope catchSelectionBlock isNotNil.
	exceptionScope catchSelectionBlock == exceptionScope unwindCleanUpBlock ifTrue: [ ^ self ].
	
	self slvmBuilder currentBlock: exceptionScope catchSelectionBlock.
	self withUnwindBlock: self validForbiddenExceptionDuringCleanupTarget do: [ 
		exceptionScope catchedExceptions do: [ :each |
			self generateUnwindingCatchTestingForException: each
		].
		
		self slvmBuilder jump: exceptionScope unwindCleanUpBlock
	].
]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingCatchTestingForException: catchedException [
	| typeInfoConstant typeInfoSelector currentSelector isMatchingTypeInfo exceptionSelectContinueBlock |
	typeInfoConstant := (codeModuleGenerator translateProgramEntity: catchedException node exceptionType) ssaValue.
	currentSelector := self slvmBuilder load: self unwindExceptionSelectorVariable.
	typeInfoSelector := self slvmBuilder getExceptionSelectorForTypeInfo: typeInfoConstant.
	isMatchingTypeInfo := self slvmBuilder ieq: currentSelector with: typeInfoSelector.
	exceptionSelectContinueBlock := self slvmBuilder newBasicBlock: #catchSelectContinue.
	catchedException node exceptionTypeIsLiteral ifTrue: [
		self assert: self slvmBuilder currentBlock mergeBlock isNil.
		self slvmBuilder currentBlock mergeBlock: exceptionSelectContinueBlock.
		self slvmBuilder branch: isMatchingTypeInfo ifTrue: catchedException catchActionBlock ifFalse: exceptionSelectContinueBlock.
	] ifFalse: [
		"This is a case that requires further testing."
		self halt.
	].

	self slvmBuilder currentBlock: exceptionSelectContinueBlock
]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingCleanUpFor: exceptionScope [
	| resumeValue |
	self assert: self slvmBuilder currentUnwindBlock isNil.
	self assert: exceptionScope unwindCleanUpBlock isEmpty.
	self slvmBuilder currentBlock: exceptionScope unwindCleanUpBlock.
	self withUnwindBlock: self validForbiddenExceptionDuringCleanupTarget do: [ 
		self executeScopeCleanUpActions: exceptionScope.
	].
	
	self slvmBuilder isLastTerminator ifTrue: [ ^ self ].

	"If this block is empty, it cannot have an unwind destination anymore."
	self slvmBuilder currentBlock isEmpty ifTrue: [ self slvmBuilder currentBlock unwindBlock: nil ].
	
	exceptionScope parent ifNotNil: [ :parent |
		"If this is inside a catch, we need to skip the catch selection clauses from the parent."
		exceptionScope parentCatchAction ifNotNil: [
			self assert: parent unwindCleanUpBlock isNotNil.
			^ self slvmBuilder jump: parent unwindCleanUpBlock
		].
	
		parent catchSelectionBlock ifNotNil: [ :parentCleanUp |
			^ self slvmBuilder jump: parent catchSelectionBlock
		].
	].

	self compilationTarget usesExceptionsForNonLocalReturns ifTrue: [ 
		exceptionScope nonLocalReturnContext ifNotNil: [
			self generateUnwindingNonLocalReturnCatch.
		].
	].

	resumeValue := SLVMConstant undefined: codeModuleGenerator landingPathResultType.
	resumeValue := self slvmBuilder insertValue: resumeValue value: (self slvmBuilder load: self unwindExceptionPointerVariable) indices: #(0).
	resumeValue := self slvmBuilder insertValue: resumeValue value: (self slvmBuilder load: self unwindExceptionSelectorVariable) indices: #(1).
	^ self slvmBuilder resumeException: resumeValue
]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingCode [
	| unusedUnwindBlocks unwindBlockReplacementDictionary |
	self assert: self slvmBuilder currentUnwindBlock isNil.

	"Create a list with the unused unwind blocks and a replacement dictionary for them."	
	unusedUnwindBlocks := OrderedCollection new.
	unwindBlockReplacementDictionary := Dictionary new.

	allCleanUpScopes do: [ :cleanUpScope |
		| parent |
		parent := cleanUpScope parent.
		(cleanUpScope isNopExceptionScope and: [ cleanUpScope isInCleanUpAction not ]) ifTrue: [
			| unusedUnwindBlock newUnwindBlock |
			unusedUnwindBlock := cleanUpScope unwindBlock.
			newUnwindBlock := nil.
			"These scopes are in pre-order, so parent are always before their
			children (i.e. there are topologically sorted)."
			parent ifNotNil: [
				newUnwindBlock := parent unwindBlock.
				cleanUpScope
					unwindBlock: newUnwindBlock;
					catchSelectionBlock: parent catchSelectionBlock;
					unwindCleanUpBlock: parent catchSelectionBlock.
			] ifNil: [ 
				cleanUpScope
					unwindBlock: nil;
					catchSelectionBlock: nil;
					unwindCleanUpBlock: nil.
			].
		
			unusedUnwindBlocks add: unusedUnwindBlock.
			unwindBlockReplacementDictionary at: unusedUnwindBlock put: newUnwindBlock.
		] ifFalse: [
			cleanUpScope isInCleanUpAction ifFalse: [
				cleanUpScope unwindCleanUpBlock: (self slvmBuilder newBasicBlock: #unwindCleanUp).
				cleanUpScope unwindCleanUpBlock unwindBlock: self validForbiddenExceptionDuringCleanupTarget.
				cleanUpScope catchedExceptions ifEmpty: [
					cleanUpScope catchSelectionBlock: cleanUpScope unwindCleanUpBlock
				] ifNotEmpty: [
					cleanUpScope catchSelectionBlock: (self slvmBuilder newBasicBlock: #unwindCatchSelection).
					cleanUpScope catchSelectionBlock unwindBlock: self validForbiddenExceptionDuringCleanupTarget.
				].
			].
		].
	].

	"Replace the removed unwind blocks."
	self ssaFunction basicBlocks do: [ :each |
		unwindBlockReplacementDictionary at: each unwindBlock ifPresent: [ :replacement |
			each unwindBlock: replacement
		]
	].

	"Remove the unused unwind blocks."
	unusedUnwindBlocks do: [ :each | each removeFromFunction ].
	
	"Generate the per scope landing pad, catch clauses, and cleanup."
	allCleanUpScopes do: [ :each |
		each isNopExceptionScope ifFalse: [
			self generateUnwindingCodeForExceptionScope: each 
		]
	].

	forbiddenExceptionDuringCleanupTarget ifNotNil: [
		self ssaFunction basicBlocks detect: [ :each |each unwindBlock == forbiddenExceptionDuringCleanupTarget ] ifFound: [ 
			self generateForbiddenExceptionDuringCleanupTarget
		] ifNone: [
			forbiddenExceptionDuringCleanupTarget removeFromFunction
		].
	].

	self removeUnusedCleanUpActionStates.

]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingCodeForExceptionScope: exceptionScope [
	self generateUnwindingLandingPadFor: exceptionScope.
	self generateUnwindingCatchSelectionFor: exceptionScope.
	self generateUnwindingCleanUpFor: exceptionScope.
]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingLandingPadFor: exceptionScope [
	| landingPath |
	self assert: self slvmBuilder currentUnwindBlock isNil.
	self slvmBuilder currentBlock: exceptionScope unwindBlock.
	self ssaFunction personalityFunction: codeModuleGenerator personalityFunction.

	landingPath := self slvmBuilder landingPath: codeModuleGenerator landingPathResultType.
	landingPath
		catchedExceptions: (exceptionScope flattenedCatchedExceptions collect: [:each | (self translateProgramEntity: each) ssaValue ]) reversed;
		cleanup: exceptionScope isCleanUpScopeOrParentCleanUp.

	self slvmBuilder store: (self slvmBuilder extractValue: landingPath indices: {0}) in: self unwindExceptionPointerVariable.
	self slvmBuilder store: (self slvmBuilder extractValue: landingPath indices: {1}) in: self unwindExceptionSelectorVariable.
	
	self slvmBuilder jump: exceptionScope catchSelectionBlock
]

{ #category : #'exception handling' }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> generateUnwindingNonLocalReturnCatch [
	| typeInfoConstant currentSelector typeInfoSelector isNonLocalReturnException nonLocalReturnBlock unwindResumeBlock |
	typeInfoConstant := (codeModuleGenerator translateProgramEntity: self compilationTarget internalNonLocalReturnExceptionClass) ssaValue.
	currentSelector := self slvmBuilder load: self unwindExceptionSelectorVariable.
	typeInfoSelector := self slvmBuilder getExceptionSelectorForTypeInfo: typeInfoConstant.
	isNonLocalReturnException := self slvmBuilder ieq: currentSelector with: typeInfoSelector.
	nonLocalReturnBlock := self slvmBuilder newBasicBlock: #nonLocalReturn.
	unwindResumeBlock := self slvmBuilder newBasicBlock: #unwindResume.
	self slvmBuilder currentBlock mergeBlock: unwindResumeBlock.
	self slvmBuilder branch: isNonLocalReturnException ifTrue: nonLocalReturnBlock ifFalse: unwindResumeBlock.
	
	self slvmBuilder currentBlock: nonLocalReturnBlock.
	self slvmBuilder call: codeModuleGenerator nonLocalReturnCatchFunction arguments: { self slvmBuilder load: self unwindExceptionPointerVariable }.
	self nonLocalReturnResultVariable ifNil: [
		self assert: self concreteMethod returnType isVoidType.
		self slvmBuilder returnVoid
	] ifNotNil: [
		self assert: self concreteMethod returnType isVoidType not.
		self concreteMethod returnType isMemoryReturnedType ifTrue: [ 
			self assert: (self nonLocalReturnResultVariable isFunctionArgument or: [self nonLocalReturnResultVariable isClosureCapture]).
			self slvmBuilder returnVoid
		] ifFalse: [ 
			self slvmBuilder return: (self slvmBuilder load: self nonLocalReturnResultVariable)
		]
	].

	self slvmBuilder currentBlock: unwindResumeBlock
]

{ #category : #accessing }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> unwindExceptionPointerVariable [
	^ unwindExceptionPointerVariable ifNil: [ unwindExceptionPointerVariable := self slvmBuilder allocaBuilder alloca: self slvmCompilationTarget voidPointerType name: #exceptionPointer ]
]

{ #category : #accessing }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> unwindExceptionSelectorVariable [
	^ unwindExceptionSelectorVariable ifNil: [ unwindExceptionSelectorVariable := self slvmBuilder allocaBuilder alloca: self slvmCompilationTarget int name: #exceptionSelector ]
]

{ #category : #visiting }
MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator >> validForbiddenExceptionDuringCleanupTarget [
	^ forbiddenExceptionDuringCleanupTarget ifNil: [ forbiddenExceptionDuringCleanupTarget := self slvmBuilder newBasicBlock: #forbiddenExceptionTarget ]
]
