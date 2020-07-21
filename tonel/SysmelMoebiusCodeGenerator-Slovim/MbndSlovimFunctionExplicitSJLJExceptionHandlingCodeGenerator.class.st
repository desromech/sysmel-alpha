Class {
	#name : #MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator,
	#superclass : #MbndSlovimFunctionExceptionHandlingCodeGenerator,
	#instVars : [
		'catchedExceptionTypesField',
		'catchedExceptionDescriptorField',
		'landingPadContextField'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> addExceptionBeginContextCallFor: exceptionScope [
	| beginContextFunction exceptionContext bitcastInstruction |
	beginContextFunction := self codeModuleGenerator exceptionContextBeginFunction.
	exceptionContext := exceptionScope exceptionContext.
	bitcastInstruction := SLVMBitCast source: exceptionContext targetType: beginContextFunction functionType arguments first.
	exceptionScope scopeEntryBlock addInstructions: {
		bitcastInstruction .
		(SLVMCall function: beginContextFunction arguments: {bitcastInstruction})
			debugSourceLocation: self slvmBuilder currentDebugSourceLocation
	} after: nil
]

{ #category : #accessing }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> catchedExceptionDescriptorField [
	^ catchedExceptionDescriptorField ifNil: [ catchedExceptionDescriptorField := self compilationTarget exceptionContextType findFirstFieldNamed: #catchedExceptionDescriptor ]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> catchedExceptionDescriptorFor: exceptionScope [
	| unwindCleanUpFlag catchedExceptionTypeCount nonLocalReturnFlag |
	nonLocalReturnFlag := exceptionScope unwindNonLocalReturnBlock isNotNil asBit.
	unwindCleanUpFlag := exceptionScope unwindCleanUpBlock isNotNil asBit.
	catchedExceptionTypeCount := exceptionScope catchedExceptions size.
	^ SLVMConstant type: (self translateType: self catchedExceptionDescriptorField valueType)
		value: (nonLocalReturnFlag << 16) | (unwindCleanUpFlag << 17) | catchedExceptionTypeCount
]

{ #category : #accessing }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> catchedExceptionTypesField [
	^ catchedExceptionTypesField ifNil: [ catchedExceptionTypesField := self compilationTarget exceptionContextType findFirstFieldNamed: #catchedExceptionTypes ]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> catchedExceptionTypesFor: exceptionScope [
	| exceptionTypes requiredResultType constantType result voidPointerType |
	requiredResultType := self translateType: self catchedExceptionTypesField valueType.
	exceptionScope catchedExceptions ifEmpty: [ ^ SLVMConstant nullPointer: requiredResultType ].
	exceptionTypes := exceptionScope catchedExceptions collect: [ :each | self visitNode: each node exceptionTypeExpression ].
	voidPointerType := self slvmCompilationTarget voidPointerType.
	constantType := SLVMArrayType baseType: voidPointerType elements: exceptionTypes size.
	result := self slvmBuilder allocaBuilder alloca: constantType.
	exceptionTypes doWithIndex: [ :type :index |
		self slvmBuilder store: (self slvmBuilder bitCast: type target: voidPointerType)
			in: (self slvmBuilder getReference: result element: (self slvmBuilder constInt: index - 1))
	].
	
	^ self slvmBuilder bitCast: result target: requiredResultType
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> emitCleansUpBySupressing: suppresedCleanUpTokens forReturningWith: aBlock [
	self endAllCatchingScopes.
	self executeAllScopeCleanUpExceptForTokens: suppresedCleanUpTokens.
	aBlock value
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> endAllCatchingScopes [
	| position |
	position := currentCleanUpScope.
	[ position ] whileNotNil: [
		self endExceptionScope: position.
		position := position parent
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> endExceptionScope: cleanUpScope [
	| endScopeFunction |
	"Nop clean ups are removed"
	cleanUpScope exceptionContext ifNil: [ ^ nil ].
	endScopeFunction := self codeModuleGenerator exceptionContextEndFunction.
	self slvmBuilder call: endScopeFunction arguments: {
		self slvmBuilder bitCast: cleanUpScope exceptionContext target: endScopeFunction functionType arguments first
	}.

]

{ #category : #'cleanup scopes' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> executeScopeCleanUpActions: cleanUpScope exceptForTokens: suppressedCleanUpTokens [
	self inCleanUpContextDo: [ 
		cleanUpScope implicitFinalizationStateDictionary valuesDo: [ :action |
			(suppressedCleanUpTokens includes: action token) ifFalse: [ 
				self executeImplicitFinalizationAction: action
			].
		].
		cleanUpScope explicitFinalizationAction ifNotNil: [ :ac |
			ac value
		].

		cleanUpScope parentCatchAction ifNotNil: [
			self generateExceptionCatchEndFor: cleanUpScope parent
		].
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateCatchedExceptionAction: scopeCatchedExceptionAction [
	| catchExceptionScope |
	"We need a special scope for connecting with the finally action."
	catchExceptionScope := MbndSlovimExceptionScope new
		parent: currentCleanUpScope;
		parentCatchAction: scopeCatchedExceptionAction;
		compilationTarget: self compilationTarget;
		scopeEntryBlock: scopeCatchedExceptionAction catchActionBlock;
		normalCleanUpBlock: (self slvmBuilder newBasicBlock: #catchNormalCleanUp);
		isInCleanUpAction: false;
		yourself.
	allCleanUpScopes add: catchExceptionScope.

	self slvmBuilder withBasicBlock: scopeCatchedExceptionAction catchActionBlock do: [
		| caughtExceptionReference |
		caughtExceptionReference := self generateExceptionCatchBeginFor: catchExceptionScope parent.
		scopeCatchedExceptionAction node caughtExceptionReferenceNode ifNotNil: [ :refNode |
			functionCodeGenerator setVariable: caughtExceptionReference forNode: refNode.
		].
	
		self withExceptionScope: catchExceptionScope do: [ 
			self visitNode: scopeCatchedExceptionAction node catchAction.
		].
	
		(catchExceptionScope normalCleanUpBlock predecessors isNotEmpty) ifTrue: [ 
			self slvmBuilder isLastTerminator ifFalse: [
				self slvmBuilder jump: catchExceptionScope normalCleanUpBlock.
			].

			self slvmBuilder currentBlock: catchExceptionScope normalCleanUpBlock.
		] ifFalse: [
			"A separate normal clean up block is not needed here."
			catchExceptionScope normalCleanUpBlock removeFromFunction.
			catchExceptionScope normalCleanUpBlock: nil
		].
	
		self slvmBuilder isLastTerminator ifFalse: [
			self executeScopeCleanUpActions: catchExceptionScope.
		].

		self slvmBuilder isLastTerminator ifFalse: [
			self slvmBuilder jump: catchExceptionScope parent normalCleanUpBlock.
		].
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionCatchBeginFor: catchExceptionScope [
	| function |
	function := self codeModuleGenerator exceptionCatchBeginFunction.
	^ self slvmBuilder call: function arguments: {
		self slvmBuilder bitCast: catchExceptionScope exceptionContext target: function functionType arguments first
	}
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionCatchEndFor: exceptionScope [
	| catchEndFunction |
	self assert: exceptionScope exceptionContext isNotNil.
	catchEndFunction := self codeModuleGenerator exceptionCatchEndFunctionWithContext.
	self slvmBuilder call: catchEndFunction arguments: { 
		self slvmBuilder bitCast: exceptionScope exceptionContext target: catchEndFunction functionType arguments first
	}
]

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionScopeNode: node [

	| cleanUpScope result tryEnterBlock exceptionContextType tryBodyEnd |
	exceptionContextType := self compilationTarget exceptionContextType.
	cleanUpScope := MbndSlovimExceptionScope new
		parent: currentCleanUpScope;
		compilationTarget: self compilationTarget.
	(currentCleanUpScope isNil and: self nonLocalReturnContext isNotNil) ifTrue: [ 
		self assert: self nonLocalReturnContext isBitCast.
		cleanUpScope
			nonLocalReturnContext: self nonLocalReturnContext;
			exceptionContext: self nonLocalReturnContext source.
	] ifFalse: [
		cleanUpScope exceptionContext: (self slvmBuilder allocaBuilder alloca: (self translateType: exceptionContextType)).
	].

	allCleanUpScopes add: cleanUpScope.
	cleanUpScope allowedNodesWithImplicitFinalization: node nodesWithImplicitFinalization.
	cleanUpScope catchedExceptions: (node catchExpressions collect: [:catchNode |
		MbndSlovimExceptionScopeCatchAction new
			scope: cleanUpScope;
			catchActionBlock: (self slvmBuilder newBasicBlock: #catchAction);
			node: catchNode;
			yourself
		]).
	

	tryEnterBlock := self slvmBuilder currentBlock.
	cleanUpScope scopeEntryBlock: (self slvmBuilder newBasicBlock: #tryBody).
	self slvmBuilder currentBlock: cleanUpScope scopeEntryBlock.

	cleanUpScope isInCleanUpAction: inCleanUpContextCount > 0.
	cleanUpScope normalCleanUpBlock: (self slvmBuilder newBasicBlock: #normalCleanUpBlock).

	"Store a block for generating the explicit finalization actions that corresponds to this clean up scope."
	node explicitCleanUpActions ifNotEmpty: [
		cleanUpScope explicitFinalizationAction: [
			node explicitCleanUpActions do: [ :cleanUpAction | self visitNode: cleanUpAction ]
		].
	].

	"Generate the body of the exception scope."
	result := self generateExceptionScopeNodeContent: node onCleanUpScope: cleanUpScope.

	tryBodyEnd := self slvmBuilder currentBlock.

	self withExceptionScope: cleanUpScope do: [
		cleanUpScope catchedExceptions do: [ :each |
			self generateCatchedExceptionAction: each
		].
	].
	
	"In the nop case, insert jumps and remove the exception context."
	cleanUpScope mustBeNopExceptionScope ifTrue: [
		self assert: cleanUpScope normalCleanUpBlock isEmpty.
		self assert: cleanUpScope normalCleanUpBlock predecessors isEmpty.
		cleanUpScope normalCleanUpBlock removeFromFunction.
		
		self removeUnusedExceptionContext: cleanUpScope exceptionContext.
		self slvmBuilder
			currentBlock: tryEnterBlock;
			jump: cleanUpScope scopeEntryBlock;
			currentBlock: tryBodyEnd.
		^ result
	].

	self generateExceptionScopeNormalCleanup: cleanUpScope.
	self generateExceptionScopeUnwindNonLocalReturn: cleanUpScope.
	self generateExceptionScopeUnwindCleanup: cleanUpScope.
	self generateExceptionTrySetupAt: tryEnterBlock for: cleanUpScope.
	^ result
]

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionScopeNormalCleanup: exceptionScope [
	self slvmBuilder isLastTerminator ifFalse: [
		self endExceptionScope: exceptionScope.
	].

	(exceptionScope normalCleanUpBlock predecessors isNotEmpty) ifTrue: [ 
		self slvmBuilder isLastTerminator ifFalse: [
			self slvmBuilder jump: exceptionScope normalCleanUpBlock.
		].

		self slvmBuilder currentBlock: exceptionScope normalCleanUpBlock.
	] ifFalse: [
		"A separate normal clean up block is not needed here."
		exceptionScope normalCleanUpBlock removeFromFunction.
		exceptionScope normalCleanUpBlock: nil
	].

	self slvmBuilder isLastTerminator ifFalse: [ 
		self executeScopeCleanUpActions: exceptionScope
	].
]

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionScopeUnwindCleanup: exceptionScope [
	| unwindCleanUp |
	unwindCleanUp := self slvmBuilder newBasicBlock: #unwindCleanUp.
	self slvmBuilder withBasicBlock: unwindCleanUp do: [
		self executeScopeCleanUpActions: exceptionScope.
		(unwindCleanUp isEmpty not and: [self slvmBuilder isLastTerminator not]) ifTrue: [
			| endCleanUpFunction |
			endCleanUpFunction := self codeModuleGenerator exceptionCleanUpEndFunction.
			self slvmBuilder
				call: endCleanUpFunction arguments: {
					self slvmBuilder bitCast: exceptionScope exceptionContext target: endCleanUpFunction functionType arguments first
				};
				unreachable
		]
	].
	unwindCleanUp isEmpty ifTrue: [
		unwindCleanUp removeFromFunction.
		^ self
	].

	exceptionScope unwindCleanUpBlock: unwindCleanUp.
]

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionScopeUnwindNonLocalReturn: exceptionScope [
	| unwindNonLocalReturn |
	exceptionScope nonLocalReturnContext ifNil: [ ^ self ].
	
	unwindNonLocalReturn := self slvmBuilder newBasicBlock: #unwindNonLocalReturn.
	self slvmBuilder withBasicBlock: unwindNonLocalReturn do: [
		self executeScopeCleanUpActions: exceptionScope.
		self generateReturnFromNonLocalReturnHandler
	].

	exceptionScope unwindNonLocalReturnBlock: unwindNonLocalReturn.
]

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateExceptionTrySetupAt: tryEnterBlock for: exceptionScope [
	| invalidCaughtException setjmpResult switchDestinations switchConstants |
	invalidCaughtException := self slvmBuilder newBasicBlock: #invalidCaughtException.
	self slvmBuilder withBasicBlock: invalidCaughtException do: [
		self slvmBuilder unreachable
	].

	self slvmBuilder withBasicBlock: tryEnterBlock do: [
		| exceptionContext exceptionContextType setjmpFunction |
		exceptionContext := exceptionScope exceptionContext.
		exceptionContextType := self compilationTarget exceptionContextType.
		setjmpFunction := self codeModuleGenerator exceptionSetjmpFunction.

		self slvmBuilder
			store: (SLVMConstant zeroInitializer: (self translateType: exceptionContextType)) in: exceptionContext; 
			store: (self catchedExceptionDescriptorFor: exceptionScope)
				in: (self slvmBuilder getReference: exceptionContext element: (self slvmBuilder constInt: self catchedExceptionDescriptorField slotIndex));
			store: (self catchedExceptionTypesFor: exceptionScope)
				in: (self slvmBuilder getReference: exceptionContext element: (self slvmBuilder constInt: self catchedExceptionTypesField slotIndex)).
				
			setjmpResult := self slvmBuilder call: setjmpFunction arguments: {
				self slvmBuilder bitCast:
					(self slvmBuilder getReference: exceptionContext element: (self slvmBuilder constInt: self landingPadContextField slotIndex))
					target: setjmpFunction functionType arguments first 
				}.
			switchDestinations := { exceptionScope scopeEntryBlock } ,
				(exceptionScope unwindNonLocalReturnBlock ifNil: [ #() ] ifNotNil: [:b | {b}]) ,
				(exceptionScope unwindCleanUpBlock ifNil: [ #() ] ifNotNil: [:b | {b}]) ,
				(exceptionScope catchedExceptions collect: [:each | each catchActionBlock]).
			switchConstants := (0 to: switchDestinations size - 1) collect: [ :i | self slvmBuilder constInt: i].
			self slvmBuilder switch: setjmpResult caseConstants: switchConstants caseBlocks: switchDestinations defaultBlock: invalidCaughtException
	].

	self addExceptionBeginContextCallFor: exceptionScope
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateNonLocalReturnContext [
	| nonLocalReturnContext |
	nonLocalReturnContext := self slvmBuilder allocaBuilder alloca: (self translateType: self compilationTarget exceptionContextType).
	^ self slvmBuilder 
		bitCast: nonLocalReturnContext target: (self translateType: self concreteMethod getNonLocalReturnTarget type)
]

{ #category : #'code generation' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> generateUnwindingCode [
	self removeUnusedCleanUpActionStates.

]

{ #category : #accessing }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> landingPadContextField [
	^ landingPadContextField ifNil: [ landingPadContextField := self compilationTarget exceptionContextType findFirstFieldNamed: #landingPadContext ]
]

{ #category : #removing }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> removeUnusedExceptionContext: exceptionContextVariable [
	self assert: (self unusedExceptionContextCanBeRemoved: exceptionContextVariable).
	exceptionContextVariable removeFromBlockWithAllReferences
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator >> unusedExceptionContextCanBeRemoved: exceptionContextVariable [
	exceptionContextVariable instructionReferences do: [ :each |
		| callInstruction |
		callInstruction := each.
		(each isBitCast and: [ each instructionReferences size = 1 ]) ifTrue: [ 
			callInstruction := each instructionReferences first.
		].
	
		(callInstruction isCall and: [ callInstruction functionValue == self codeModuleGenerator exceptionContextEndFunction ]) ifFalse: [ ^ false ]
	].

	^ true
]
