"
A MbndAstSemanticAnalyzerTest is a test class for testing the behavior of MbndAstSemanticAnalyzer
"
Class {
	#name : #MbndAstSemanticAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'scope',
		'visitor',
		'compilationTarget'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-SemanticAnalysis'
}

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> computeAnalyzedCastNodeWithCastFunction: castFunctionDefinition [
	| analyzedCastFunction concreteMethod |
	analyzedCastFunction := visitor visitNode: castFunctionDefinition.
	concreteMethod := analyzedCastFunction concreteMethod.
	
	"Remove the concrete method for reusing its name."
	concreteMethod parent localSymbolTable removeKey: concreteMethod name.
	concreteMethod parent children removeAll.
	
	"Analyze the concrete method."
	concreteMethod ensureSemanticAnalysis.
	^ concreteMethod analyzedBody
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzerTest >> countTwiceFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #destCount type: compilationTarget int32Type.
	}.
	body := builder sequence: {
		(builder defineLocalVariable: #i withValueType: nil withInitialValue: (builder literalInteger: 0))
			mutable.
		(builder defineLocalVariable: #count withValueType: nil withInitialValue: (builder literalInteger: 0))
			mutable.
			
		builder while: (builder unexpandedSend: (builder literalSymbol: #<)
			to: (builder identifier: #i) withArguments: {(builder identifier: #destCount)})
			do: (builder sequence: {
				builder unexpandedSend: (builder literalSymbol: #assignValue:)
					to:  (builder identifier: #count)
					withArguments: {
						builder unexpandedSend: (builder literalSymbol: #+)
							to: (builder identifier: #count) withArguments: { builder literalInteger: 2 }.
					}
			}) continueWith: (builder unexpandedSend: (builder literalSymbol: #assignValue:)
					to:  (builder identifier: #i)
					withArguments: {
						builder unexpandedSend: (builder literalSymbol: #+)
							to: (builder identifier: #i) withArguments: { builder literalInteger: 1 }.
					}).
		builder identifier: #count
	}.
	
	^ builder functionNamed: #countTwice arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> explicitAnalyzedCastNodeFrom: sourceType to: targetType [
	| castFunction |
	castFunction := self explicitCastFunctionDefinitionFrom: sourceType to: targetType.
	^ self computeAnalyzedCastNodeWithCastFunction: castFunction
	
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> explicitCastFunctionDefinitionFrom: sourceType to: targetType [
	| arguments body |
	arguments := {
		builder argument: #x type: sourceType.
	}.
	body := builder explicitCast: (builder identifier: #x) to: targetType.
	^ builder functionNamed: #castFunction arguments: arguments returnType: targetType definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> identityFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	^ builder functionNamed: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> identityMessageDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	^ builder messageSelector: #identity: arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> identityTopMacroDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: nil.
	}.
	body := builder identifier: #x.
	^ builder macroMessageSelector: #identity: arguments: arguments returnType: nil definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> implicitAnalyzedCastNodeFrom: sourceType to: targetType [
	| castFunction |
	castFunction := self implicitCastFunctionDefinitionFrom: sourceType to: targetType.
	^ self computeAnalyzedCastNodeWithCastFunction: castFunction
	
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> implicitCastFunctionDefinitionFrom: sourceType to: targetType [
	| arguments body |
	arguments := {
		builder argument: #x type: sourceType.
	}.
	body := builder implicitCast: (builder identifier: #x) to: targetType.
	^ builder functionNamed: #castFunction arguments: arguments returnType: targetType definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> libcPrintfDeclarationNode [
	| arguments |
	arguments := {
		builder argument: #format type: compilationTarget cstringLiteralType
	}.
	^ (builder functionPrototypeNamed: #printf arguments: arguments returnType: compilationTarget int32Type)
		externC;
		CVariadic;
		yourself
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> libcPutsDefinitionNode [
	| arguments |
	arguments := {
		builder argument: #s type: compilationTarget cstringLiteralType
	}.
	^ (builder functionPrototypeNamed: #puts arguments: arguments returnType: compilationTarget int32Type)
		externC;
		yourself
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> minFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #a type: compilationTarget int32Type.
		builder argument: #b type: compilationTarget int32Type.
	}.
	body := builder if: (builder unexpandedSend: (builder literalSymbol: #<=)
			to: (builder identifier: #a) withArguments: { builder identifier: #b })
		trueValue: (builder identifier: #a) falseValue: (builder identifier: #b).
	^ builder functionNamed: #min arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> reinterpretAnalyzedCastNodeFrom: sourceType to: targetType [
	| castFunction |
	castFunction := self reinterpretCastFunctionDefinitionFrom: sourceType to: targetType.
	^ self computeAnalyzedCastNodeWithCastFunction: castFunction
	
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> reinterpretCastFunctionDefinitionFrom: sourceType to: targetType [
	| arguments body |
	arguments := {
		builder argument: #x type: sourceType.
	}.
	body := builder reinterpretCast: (builder identifier: #x) to: targetType.
	^ builder functionNamed: #castFunction arguments: arguments returnType: targetType definitionBody: body
]

{ #category : #running }
MbndAstSemanticAnalyzerTest >> setUp [
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
	builder := MbndAstBuilder forModule: module.
	scope := module newGenericAnalysisScope.
	visitor := MbndAstSemanticAnalyzer new
		scope: scope;
		module: module
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testArrayConstructionNode [
	| node one two analyzedNode |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder constructArrayOf: (builder identifier: #Float32) withElements: { one . two }.
	analyzedNode := visitor visitNode: node.
	
	self assert: analyzedNode type elements equals: 2.
	self assert: analyzedNode type elementType equals: compilationTarget float32Type.
	self assert: analyzedNode isLiteralValueNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testBlockClosure [
	| arguments node analyzedNode body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder blockClosureWithArguments: arguments returnType: compilationTarget int32Type body: body.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isBlockClosureNode.
	self assert: analyzedNode type isBlockClosureType.
	self assert: analyzedNode type argumentTypes size equals: 1.
	self assert: analyzedNode type argumentTypes first isPrimitiveIntegerType.
	self assert: analyzedNode type returnType isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testChainedCast [
	| node analyzedNode chainedCast |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: compilationTarget int8Type withInitialValue: (builder literalInteger: 5))
			mutable.
		builder explicitCast: (builder identifier: #x) to: compilationTarget int64Type
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	
	chainedCast := analyzedNode elements last.
	self assert: chainedCast isSignExtensionCastNode.
	self assert: chainedCast expression isReferenceLoadNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #class.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isClassDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isClassType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassDefinitionBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #class.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isClassDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isClassType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassDefinitionWithSuperclassBuilderExpansion [
	| node superClassDefinitionNode subClassDefinitionNode |
	node := builder identifier: #class.
	node := builder unexpandedSend: (builder literalSymbol: #BinaryStream) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	superClassDefinitionNode := visitor visitNode: node.
	
	self assert: superClassDefinitionNode isClassDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #BinaryStream ifAbsent: [nil]) isNotNil.
	self assert: superClassDefinitionNode binding isNotNil.
	self assert: superClassDefinitionNode binding isClassType.
	self assert: superClassDefinitionNode binding type instanceType equals: superClassDefinitionNode binding.

	node := builder identifier: #class.
	node := builder unexpandedSend: (builder literalSymbol: #BinaryFileStream) to: node withArguments: #().
	node := builder messageChainReceiver: node messages: { 
		builder unexpandedSend: (builder literalSymbol: #superclass:) to: node withArguments: {
			builder identifier: #BinaryStream
		}.

		builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
			builder sequence: #()
		}.
	}.
	
	subClassDefinitionNode := visitor visitNode: node.
	
	self assert: subClassDefinitionNode isClassDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #BinaryFileStream ifAbsent: [nil]) isNotNil.
	self assert: subClassDefinitionNode binding isNotNil.
	self assert: subClassDefinitionNode binding isClassType.
	self assert: subClassDefinitionNode binding type instanceType equals: subClassDefinitionNode binding.
	self assert: subClassDefinitionNode binding type supertype equals: superClassDefinitionNode binding type.
	self assert: subClassDefinitionNode binding type instanceType supertype equals: superClassDefinitionNode binding type instanceType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassNoOverrideError [
	| classNode classType |
	classNode := builder defineClass: (builder declareClass: #SuperClass) superclass: nil body: (builder sequence: {
		builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil.
		(builder functionPrototypeNamed: #virtualMethod arguments: #() returnType: (builder identifier: #Void))
			override.
	}).

	classNode := visitor visitNode: classNode.
	classType := classNode binding.
	self assert: classType virtualMethods size equals: 1.

	self should: [classType ensureSemanticAnalysis] raise: MbndCompilationError.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassVirtualMethodShadowWarning [
	| superClassNode subClassNode superClass subClass |
	superClassNode := builder defineClass: (builder declareClass: #SuperClass) superclass: nil body: (builder sequence: {
		builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil.
		(builder functionPrototypeNamed: #virtualMethod arguments: #() returnType: (builder identifier: #Void))
			virtual.
	}).
	
	subClassNode := builder defineClass: (builder declareClass: #SubClass) superclass: (builder identifier: #SuperClass) body: (builder sequence: {
		builder defineField: #floatField withValueType: (builder identifier: #Float32) withInitialValue: nil.
		(builder functionPrototypeNamed: #virtualMethod arguments: #() returnType: (builder identifier: #Void))
			virtual.
	}).
	
	superClassNode := visitor visitNode: superClassNode.
	subClassNode := visitor visitNode: subClassNode.
	
	superClass := superClassNode binding.
	subClass := subClassNode binding.
	self assert: subClass supertype equals: superClass.

	self assert: superClass virtualMethods size equals: 1.
	self assert: subClass virtualMethods size equals: 1.
	
	self should: [subClass ensureSemanticAnalysis] raise: MbndCompilationWarning.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassWithSuperclass [
	| superClassNode subClassNode superClass subClass |
	superClassNode := builder defineClass: (builder declareClass: #SuperClass) superclass: nil body: (builder sequence: {
		builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil
	}).
	
	subClassNode := builder defineClass: (builder declareClass: #SubClass) superclass: (builder identifier: #SuperClass) body: (builder sequence: {
		builder defineField: #floatField withValueType: (builder identifier: #Float32) withInitialValue: nil
	}).
	
	superClassNode := visitor visitNode: superClassNode.
	subClassNode := visitor visitNode: subClassNode.
	
	superClass := superClassNode binding.
	subClass := subClassNode binding.
	self assert: subClass supertype equals: superClass.
	
	subClass ensureSemanticAnalysis.
	self assert: superClass slotLayout slots size equals: 1.
	self assert: superClass slotLayout instanceSize equals: 4.
	self assert: subClass slotLayout slots size equals: 2.
	self assert: subClass slotLayout instanceSize equals: 8.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testClassWithSuperclassVirtualMethod [
	| superClassNode subClassNode superClass subClass |
	superClassNode := builder defineClass: (builder declareClass: #SuperClass) superclass: nil body: (builder sequence: {
		builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil.
		(builder functionPrototypeNamed: #firstVirtualMethod arguments: #() returnType: (builder identifier: #Void))
			virtual.
	}).
	
	subClassNode := builder defineClass: (builder declareClass: #SubClass) superclass: (builder identifier: #SuperClass) body: (builder sequence: {
		builder defineField: #floatField withValueType: (builder identifier: #Float32) withInitialValue: nil.
		(builder functionNamed: #firstVirtualMethod arguments: #() returnType: (builder identifier: #Void)
			definitionBody: (builder sequence: #()))
			override.

		(builder functionPrototypeNamed: #secondVirtualMethod arguments: #() returnType: (builder identifier: #Void))
			virtual.
	}).
	
	superClassNode := visitor visitNode: superClassNode.
	subClassNode := visitor visitNode: subClassNode.
	
	superClass := superClassNode binding.
	subClass := subClassNode binding.
	self assert: subClass supertype equals: superClass.

	self assert: superClass virtualMethods size equals: 1.
	self assert: subClass virtualMethods size equals: 2.
	
	subClass ensureSemanticAnalysis.
	self assert: superClass slotLayout slots size equals: 2.
	self assert: superClass slotLayout instanceSize equals: 8.
	self assert: superClass slotLayout mainVirtualTable vtableSlots size equals: 1.
	
	self assert: subClass slotLayout slots size equals: 3.
	self assert: subClass slotLayout instanceSize equals: 12.
	self assert: subClass slotLayout mainVirtualTable vtableSlots size equals: 2.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCleanUpScopeNode [
	| node expression cleanUpActions analyzedNode |
	expression := builder literalInteger: 42.
	cleanUpActions := {builder literalVoid}.
	node := builder cleanUpScope: expression actions: cleanUpActions.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isCleanUpScopeNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCleanUpScopeNode2 [
	| node expression cleanUpActions analyzedNode |
	expression := builder identifier: #Int32.
	cleanUpActions := {builder literalVoid}.
	node := builder cleanUpScope: expression actions: cleanUpActions.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isCleanUpScopeNode.
	self assert: analyzedNode type isMetaType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCompileTimeConstantDefinition [
	| node analyzedNode |
	node := builder alias: #int definition: (builder identifier: #Int32).

	self assert: (module globalNamespace lookupSymbol: #int) isNil.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isVoidType.
	self assert: (module globalNamespace lookupSymbol: #int) isCompileTimeConstant.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCompileTimeConstantReference [
	| node analyzedNode |
	node := builder sequence: {
		builder alias: #int definition: (builder identifier: #Int32).
		builder identifier: #int
	}.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isMetaType.
	self assert: analyzedNode elements last isLiteralValueNode.
	self assert: analyzedNode elements last value isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCountTwiceFunctionDefinition [
	| node analyzedNode concreteMethod |
	node := self countTwiceFunctionDefinitionNode.
	
	self assert: (module globalNamespace lookupSymbol: #countTwice) isNil.
		
	analyzedNode := visitor visitNode: node.
	self assert: (module globalNamespace lookupSymbol: #countTwice) isMethod.
	self deny: (module globalNamespace lookupSymbol: #countTwice) isMethodGroup.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: (module globalNamespace lookupSymbol: #countTwice) equals: concreteMethod.
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testDummyLexicalScopeNode [
	| node analyzedNode |
	node := builder lexicalScope: (builder sequence: {
		builder literalInteger: 1.
		builder literalInteger: 42
	}).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testDummyLexicalScopeWithSingleLiteral [
	| node analyzedNode literalNode |
	literalNode := builder literalInteger: 42.
	node := builder lexicalScope: literalNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: literalNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testEnumDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #enum.
	node := builder unexpandedSend: (builder literalSymbol: #TestEnum) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isEnumDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #TestEnum ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isEnumType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testEnumDefinitionBuilderExpansion [
	| node analyzedNode enumType |
	node := builder identifier: #enum.
	node := builder unexpandedSend: (builder literalSymbol: #TestEnum) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #valueType:) to: node withArguments: {
		builder identifier: #UInt16.
	}.
	node := builder unexpandedSend: (builder literalSymbol: #values:) to: node withArguments: {
		builder dictionary: {
			builder associationKey: (builder literalSymbol: #First) value: (builder literalInteger: 1).
			builder associationKey: (builder literalSymbol: #Second) value: (builder literalInteger: 2).
		}
	}.
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isEnumDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #TestEnum ifAbsent: [nil]) isNotNil.
	enumType := analyzedNode binding.
	self assert: enumType isNotNil.
	self assert: enumType isEnumType.
	self assert: enumType type instanceType equals: enumType.
	self assert: enumType valueType equals: compilationTarget uint16Type.
	self assert: (enumType values at: #First) type equals: enumType.
	self assert: (enumType values at: #First) value equals: 1.
	self assert: (enumType values at: #Second) type equals: enumType.
	self assert: (enumType values at: #Second) value equals: 2.
	

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testEnumDefinitionBuilderExpansion2 [
	| node analyzedNode enumType |
	node := builder identifier: #enum.
	node := builder unexpandedSend: (builder literalSymbol: #TestEnum) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #values:) to: node withArguments: {
		builder dictionary: {
			builder associationKey: (builder literalSymbol: #Zero) value: nil.
			builder literalSymbol: #First.
			builder associationKey: (builder literalSymbol: #Second) value: nil.
			builder associationKey: (builder literalSymbol: #Fifth) value: (builder literalInteger: 5).
			builder literalSymbol: #Sixth.
		}
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isEnumDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #TestEnum ifAbsent: [nil]) isNotNil.
	enumType := analyzedNode binding.
	self assert: enumType isNotNil.
	self assert: enumType isEnumType.
	self assert: enumType type instanceType equals: enumType.
	self assert: enumType valueType equals: compilationTarget int32Type.
	self assert: (enumType values at: #Zero) type equals: enumType.
	self assert: (enumType values at: #Zero) value equals: 0.
	self assert: (enumType values at: #First) type equals: enumType.
	self assert: (enumType values at: #First) value equals: 1.
	self assert: (enumType values at: #Second) type equals: enumType.
	self assert: (enumType values at: #Second) value equals: 2.
	self assert: (enumType values at: #Fifth) type equals: enumType.
	self assert: (enumType values at: #Fifth) value equals: 5.
	self assert: (enumType values at: #Sixth) type equals: enumType.
	self assert: (enumType values at: #Sixth) value equals: 6.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testFloatingPointCast [
	| float16Type float32Type float64Type |
	float16Type := compilationTarget float16Type.
	float32Type := compilationTarget float32Type.
	float64Type := compilationTarget float64Type.

	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: float32Type) isFloatingPointSizeCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: float64Type) isFloatingPointSizeCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: float16Type) isFloatingPointSizeCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: float64Type) isFloatingPointSizeCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: float16Type) isFloatingPointSizeCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: float32Type) isFloatingPointSizeCastNode.

	self assert: (self implicitAnalyzedCastNodeFrom: float16Type to: float32Type) isFloatingPointSizeCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: float16Type to: float64Type) isFloatingPointSizeCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: float32Type to: float64Type) isFloatingPointSizeCastNode.

	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: float16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: float16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: float32Type] raise: Error.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testFloatingPointToIntegerCast [
	| int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type float16Type float32Type float64Type |
	int8Type := compilationTarget int8Type.
	int16Type := compilationTarget int16Type.
	int32Type := compilationTarget int32Type.
	int64Type := compilationTarget int64Type.
	uint8Type := compilationTarget uint8Type.
	uint16Type := compilationTarget uint16Type.
	uint32Type := compilationTarget uint32Type.
	uint64Type := compilationTarget uint64Type.
	float16Type := compilationTarget float16Type.
	float32Type := compilationTarget float32Type.
	float64Type := compilationTarget float64Type.

	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: int8Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: int16Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: int32Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: int64Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: uint8Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: uint16Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: uint32Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float16Type to: uint64Type) isFloatingPointToIntegerCastNode.

	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: int8Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: int16Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: int32Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: int64Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: uint8Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: uint16Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: uint32Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float32Type to: uint64Type) isFloatingPointToIntegerCastNode.

	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: int8Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: int16Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: int32Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: int64Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: uint8Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: uint16Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: uint32Type) isFloatingPointToIntegerCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: float64Type to: uint64Type) isFloatingPointToIntegerCastNode.

	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: int16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: int32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: int64Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: uint16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: uint32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float16Type to: uint64Type] raise: Error.

	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: int16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: int32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: int64Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: uint16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: uint32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float32Type to: uint64Type] raise: Error.

	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: int16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: int32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: int64Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: uint16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: uint32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: float64Type to: uint64Type] raise: Error.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGCClassDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #gcclass.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isGCClassDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isGCClassType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGCClassDefinitionBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #gcclass.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isGCClassDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isGCClassType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGlobalVariableMutableAssignment [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineGlobalVariable: #x withValueType: (builder identifier: #Int32) withInitialValue: nil)
			mutable.
		builder reference: (builder identifier: #x) assignValue: (builder literalInteger: 5).
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGlobalVariableMutableDefaultInitialValue [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineGlobalVariable: #x withValueType: compilationTarget int32Type withInitialValue: nil)
			mutable.
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGlobalVariableMutableReference [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineGlobalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGlobalVariableMutableReferenceAddress [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineGlobalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder unexpandedSend: (builder literalSymbol: #address)
			to: (builder identifier: #x)
			withArguments: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPointerType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGlobalVariableMutableReferenceExplicitLoad [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineGlobalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder referenceLoad: (builder identifier: #x)
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testGlobalVariableMutableReferenceImplicitLoad [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineGlobalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder unexpandedSend: (builder literalSymbol: #+)
			to: (builder identifier: #x)
			withArguments: { 
			(builder literalInteger: 1)
		}
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionApplySend [
	| node analyzedNode |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder unexpandedSend: (builder literalSymbol: #applyWithArguments:)
			to: (builder identifier: #identity)
			withArguments: {builder tuple: { 
				builder literalInteger: 5
			}}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionCall [
	| node analyzedNode |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder call: (builder identifier: #identity) arguments: { 
			builder literalInteger: 5
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionCallInNamespace [
	| node analyzedNode |
	node := builder sequence: {
		builder namespace: #TestNamespace definition: self identityFunctionDefinitionNode.
		builder call: (builder unexpandedSend: (builder literalSymbol: #identity)
				to: (builder identifier: #TestNamespace)
				withArguments: #()) arguments: { 
			builder literalInteger: 5
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionDefinition [
	| arguments node analyzedNode body concreteMethod |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder functionNamed: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	
	self assert: (module globalNamespace lookupSymbol: #identity) isNil.
		
	analyzedNode := visitor visitNode: node.
	self assert: (module globalNamespace lookupSymbol: #identity) isMethod.
	self deny: (module globalNamespace lookupSymbol: #identity) isMethodGroup.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: (module globalNamespace lookupSymbol: #identity) equals: concreteMethod.
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionPrototype [
	| arguments node analyzedNode |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	node := builder functionPrototypeNamed: #identity arguments: arguments returnType: compilationTarget int32Type.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isFunctionPrototypeNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionReference [
	| node analyzedNode |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder identifier: #identity
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityMessageDefinition [
	| arguments node analyzedNode body concreteMethod |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder messageSelector: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMessageMethodDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityMessagePrototype [
	| arguments node analyzedNode |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	node := builder messagePrototypeSelector: #identity arguments: arguments returnType: compilationTarget int32Type.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMessageMethodPrototypeNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityMessageSend [
	| node analyzedNode |
	node := builder sequence: {
		self identityMessageDefinitionNode.
		builder unexpandedSend: (builder literalSymbol: #identity:) to: nil withArguments: { 
			builder literalInteger: 5
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityTopMacroDefinition [
	| node analyzedNode concreteMethod |
	node := self identityTopMacroDefinitionNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMacroMessageMethodDefinitionNode.
	self assert: analyzedNode arguments first valueType isASTNodeType.
	self assert: analyzedNode returnType isASTNodeType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityTopMacroUsage [
	| analyzedNode |
	
	visitor visitNode: self identityTopMacroDefinitionNode.
	
	analyzedNode := visitor visitNode: (
		builder unexpandedSend: (builder literalSymbol: #identity:) to: nil
			withArguments: {
				builder literalInteger: 42
			}).
	self assert: analyzedNode isLiteralValueNode.
	self assert: analyzedNode value equals: 42.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIfEarlyReturn [
	| arguments body node analyzedNode concreteMethod |
	arguments := {
		builder argument: #er type: compilationTarget booleanType
	}.

	body := builder if: (builder identifier: #er)
		trueValue: (builder return: (builder literalInteger: 1)) falseValue: (builder literalInteger: 0).
	node := builder functionNamed: #earlyReturn arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	
	analyzedNode := visitor visitNode: node.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIfLiteralFalse [
	| node analyzedNode trueNode falseNode |
	trueNode := builder literalInteger: 42.
	falseNode := builder literalInteger: 0.
	node := builder if: (builder literalBooleanTrue)
		trueValue: trueNode
		falseValue: falseNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: trueNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIfLiteralTrue [
	| node analyzedNode trueNode falseNode |
	trueNode := builder literalInteger: 42.
	falseNode := builder literalInteger: 0.
	node := builder if: (builder literalBooleanTrue)
		trueValue: trueNode
		falseValue: falseNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: trueNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInlineAssemblyNode [
	| node assemblySource assembly architecture dialect inputList outputList clobberList analyzedNode |
	assemblySource := 'nop'.
	assembly := builder literalString: assemblySource.
	architecture := builder literalSymbol: #x86.
	dialect := builder literalSymbol: #gas.
	inputList := builder tuple: #().
	outputList := builder tuple: #().
	clobberList := builder tuple: #().
	node := builder inlineAssembly: assembly
		architecture: architecture
		dialect: dialect
		inputList: inputList
		outputList: outputList
		clobberList: clobberList.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isInlineAssembly.
	self assert: analyzedNode assembly equals: assemblySource.
	self assert: analyzedNode architecture equals: #x86.
	self assert: analyzedNode dialect equals: #gas.
	self assert: analyzedNode inputList equals: #().
	self assert: analyzedNode outputList equals: #().
	self assert: analyzedNode clobberList equals: #().

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIntegerBitCast [
	| int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type |
	int8Type := compilationTarget int8Type.
	int16Type := compilationTarget int16Type.
	int32Type := compilationTarget int32Type.
	int64Type := compilationTarget int64Type.
	uint8Type := compilationTarget uint8Type.
	uint16Type := compilationTarget uint16Type.
	uint32Type := compilationTarget uint32Type.
	uint64Type := compilationTarget uint64Type.
	
	self assert: (self explicitAnalyzedCastNodeFrom: uint8Type to: int8Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int8Type to: uint8Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: int16Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: uint16Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: int32Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: uint32Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint64Type to: int64Type) isBitCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int64Type to: uint64Type) isBitCastNode.

	self should: [self implicitAnalyzedCastNodeFrom: uint8Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int8Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint16Type to: int16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int16Type to: uint16Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint32Type to: int32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int32Type to: uint32Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint64Type to: int64Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int64Type to: uint64Type] raise: Error.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIntegerToFloatingPointCast [
	| int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type float16Type float32Type float64Type |
	int8Type := compilationTarget int8Type.
	int16Type := compilationTarget int16Type.
	int32Type := compilationTarget int32Type.
	int64Type := compilationTarget int64Type.
	uint8Type := compilationTarget uint8Type.
	uint16Type := compilationTarget uint16Type.
	uint32Type := compilationTarget uint32Type.
	uint64Type := compilationTarget uint64Type.
	float16Type := compilationTarget float16Type.
	float32Type := compilationTarget float32Type.
	float64Type := compilationTarget float64Type.

	self flag: 'Check me: Maybe we should forbid some of these implicit casts?. (e.g: int64 -> float16)'.
	self assert: (self implicitAnalyzedCastNodeFrom: int8Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int16Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int32Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int64Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint8Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint16Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint32Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint64Type to: float16Type) isIntegerToFloatingPointCastNode.

	self assert: (self implicitAnalyzedCastNodeFrom: int8Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int16Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int32Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int64Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint8Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint16Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint32Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint64Type to: float32Type) isIntegerToFloatingPointCastNode.

	self assert: (self implicitAnalyzedCastNodeFrom: int8Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int16Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int32Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int64Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint8Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint16Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint32Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint64Type to: float64Type) isIntegerToFloatingPointCastNode.

	self assert: (self explicitAnalyzedCastNodeFrom: int8Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int64Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint8Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: float16Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint64Type to: float16Type) isIntegerToFloatingPointCastNode.

	self assert: (self explicitAnalyzedCastNodeFrom: int8Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int64Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint8Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: float32Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint64Type to: float32Type) isIntegerToFloatingPointCastNode.

	self assert: (self explicitAnalyzedCastNodeFrom: int8Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int64Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint8Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: float64Type) isIntegerToFloatingPointCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint64Type to: float64Type) isIntegerToFloatingPointCastNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInterfaceDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #interface.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isInterfaceDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isInterfaceType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInterfaceDefinitionBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #interface.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isInterfaceDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isInterfaceType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInvalidQuasiUnquote [
	| node |
	node := builder quasiUnquote: (builder quote: (builder literalInteger: 42)).
	self should: [visitor visitNode: node] raise: MbndSemanticError.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInvalidSplice [
	| node |
	node := builder splice: (builder quote: (builder literalInteger: 42)).
	self should: [visitor visitNode: node] raise: MbndSemanticError.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetAutoMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #assignValue:) to: node withArguments: {
		builder literalInteger: 42
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isLiteralValueNode.
	self assert: analyzedNode initialValue value equals: 42.
	self assert: analyzedNode type equals: compilationTarget int32Type.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #type:) to: node withArguments: {
		compilationTarget int32Type asLiteralValueNode
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isNil.
	self assert: analyzedNode type equals: compilationTarget int32Type.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMetabuilderNameWarning [
	| node |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #class) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #assignValue:) to: node withArguments: {
		builder literalInteger: 42
	}.
	self should: [visitor visitNode: node] raise: MbndCompilationWarning.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMutableAutoMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #mutable) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #assignValue:) to: node withArguments: {
		builder literalInteger: 42
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isLiteralValueNode.
	self assert: analyzedNode initialValue value equals: 42.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType equals: compilationTarget int32Type.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMutableMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #mutable) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #type:) to: node withArguments: {
		compilationTarget int32Type asLiteralValueNode
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isNil.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType equals: compilationTarget int32Type.


]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteral [
	| literal analyzedNode |
	literal := builder literalInteger: 42.
	analyzedNode := visitor visitNode: literal.
	self assert: analyzedNode equals: literal.
	self assert: analyzedNode type isLiteralIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralAssociation [
	| literal analyzedNode key value |
	key := builder literalSymbol: #First.
	value := builder literalInteger: 1.
	literal := builder associationKey: key value: value.
	analyzedNode := visitor visitNode: literal.
	self assert: analyzedNode isAssociationNode.
	self assert: analyzedNode type isLiteralAssociationType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralIntegerExplicitCast [
	| node analyzedNode |
	node := builder explicitCast: (builder literalInteger: 42) to: (builder identifier: #Float32).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveFloatType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralIntegerImplicitCast [
	| node analyzedNode |
	node := builder implicitCast: (builder literalInteger: 42) to: (builder identifier: #Float32).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveFloatType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralIntegerReinterpretCast [
	| node analyzedNode |
	node := builder reinterpretCast: (builder literalInteger: 42) to: (compilationTarget voidType pointer).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLiteralValueNode.
	self assert: analyzedNode value equals: 42.
	self assert: analyzedNode type isPointerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralYourself [
	| literal analyzedNode node |
	literal := builder literalInteger: 42.
	node := builder unexpandedSend: (builder literalSymbol: #yourself) to: literal withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: literal.
	self assert: analyzedNode type isLiteralIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMatrixConstruction [
	| node zero one firstColumn secondColumn analyzedNode |
	zero := builder literalInteger: 0.
	one := builder literalInteger: 1.
	firstColumn := builder constructVector: (builder identifier: #Float32x2) withElements: { one . zero }.
	secondColumn := builder constructVector: (builder identifier: #Float32x2) withElements: { zero . one }.
	node := builder constructMatrix: (builder identifier: #Float32x2x2) withColumns: {firstColumn . secondColumn}.
	analyzedNode := visitor visitNode: node.
	
	self assert: analyzedNode isMatrixConstructionNode.
	self assert: analyzedNode matrixType isPrimitiveMatrixType.
	self assert: analyzedNode matrixType elementType isPrimitiveFloatType.
	self assert: analyzedNode matrixType rows equals: 2.
	self assert: analyzedNode matrixType columns equals: 2.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMatrixMatrixMultiplication [
	| node column leftMatrix rightMatrix analyzedNode |
	column := builder constructVector: (builder identifier: #Float32x2) withElements: {
		builder literalFloat: 0.0.
		builder literalFloat: 0.0.
	}.
	leftMatrix := builder constructMatrix: (builder identifier: #Float32x2x2) withColumns: {column . column}.
	rightMatrix := builder constructMatrix: (builder identifier: #Float32x2x2) withColumns: {column . column}.
	
	node := builder matrix: leftMatrix multiplicationWith: rightMatrix.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMatrixMultiplicationOperationNode.
	self assert: analyzedNode type isPrimitiveMatrixType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMatrixVectorMultiplication [
	| node leftMatrix rightMatrix analyzedNode |
	rightMatrix := builder constructVector: (builder identifier: #Float32x2) withElements: {
		builder literalFloat: 0.0.
		builder literalFloat: 0.0.
	}.
	leftMatrix := builder constructMatrix: (builder identifier: #Float32x2x2) withColumns: {rightMatrix . rightMatrix}.
	
	node := builder matrix: leftMatrix multiplicationWith: rightMatrix.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMatrixMultiplicationOperationNode.
	self assert: analyzedNode type isPrimitiveVectorType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMessageChainExpansion [
	| analyzedNode receiver messageChain |
	receiver := builder literalInteger: 42.
	messageChain := builder messageChainReceiver: receiver messages: {
		builder messageChainMessageSelector: (builder literalSymbol: #+) arguments: {builder literalInteger: 2}.
		builder messageChainMessageSelector: (builder literalSymbol: #-) arguments: {builder literalInteger: 2}.
	}.
	
	analyzedNode := visitor visitNode: messageChain.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode elements first isLocalVariableDefinitionNode.
	self assert: analyzedNode elements last isExpandedMessageSendNode.
	
	
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMessageChainExpansion2 [
	| analyzedNode receiver messageChain |
	receiver := builder literalInteger: 42.
	messageChain := builder messageChainReceiver: receiver messages: {
		builder messageChainMessageSelector: (builder literalSymbol: #+) arguments: {builder literalInteger: 2}.
	}.
	
	analyzedNode := visitor visitNode: messageChain.
	self deny: analyzedNode isMessageChainNode.
	self deny: analyzedNode isSequenceNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMessageChainExpansion3 [
	| analyzedNode receiver messageChain |
	receiver := builder literalInteger: 42.
	messageChain := builder messageChainReceiver: receiver messages: #().
	analyzedNode := visitor visitNode: messageChain.
	self assert: analyzedNode equals: receiver.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMinFunctionDefinition [
	| node analyzedNode concreteMethod |
	node := self minFunctionDefinitionNode.
	
	self assert: (module globalNamespace lookupSymbol: #min) isNil.
		
	analyzedNode := visitor visitNode: node.
	self assert: (module globalNamespace lookupSymbol: #min) isMethod.
	self deny: (module globalNamespace lookupSymbol: #min) isMethodGroup.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode arguments second valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: (module globalNamespace lookupSymbol: #min) equals: concreteMethod.
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNamespaceDefinition [
	| node analyzedNode |
	node := builder namespace: #HelloNamespace definition: (builder literalInteger: 42).

	self assert: (module globalNamespace lookupSymbol: #HelloNamespace) isNil.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isVoidType.
	self assert: (module globalNamespace lookupSymbol: #HelloNamespace) isNamespace.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNamespaceReference [
	| node analyzedNode |
	node := builder sequence: {
		builder namespace: #HelloNamespace definition: (builder literalInteger: 42).
		builder identifier: #HelloNamespace
	}.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isNamespaceType.
	self assert: analyzedNode elements last value equals: (module globalNamespace lookupSymbol: #HelloNamespace).

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNew [
	self assert: visitor scope equals: scope
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPackedStructureWithTwoFieldsDefinitionNode [
	| node body analyzedNode structure |
	body := builder sequence: {
		builder defineField: #b withValueType: (builder identifier: #Int8) withInitialValue: nil.
		builder defineField: #i withValueType: (builder identifier: #Int32) withInitialValue: nil.
	}.
	node := builder definePackedStructureNamed: #Test body: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDefinitionNode.
	
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	structure := analyzedNode binding.
	self assert: structure isNotNil.
	self assert: structure isStructureType.

	self assert: (structure lookupSymbol: #b) isNotNil.
	self assert: (structure lookupSymbol: #i) isNotNil.
	self assert: structure instanceSize equals: 5.
	self assert: structure instanceAlignment equals: 1.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerAsReference [
	| node analyzedNode |
	node := builder unexpandedSend: (builder literalSymbol: #value)
			to: (builder literal: 16r8000 type: compilationTarget int32Type pointer)
			withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isPointerAsReferenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerAsReference2 [
	| node analyzedNode |
	node := builder unexpandedSend: (builder literalSymbol: #_)
			to: (builder literal: 16r8000 type: compilationTarget int32Type pointer)
			withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isPointerAsReferenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerElementReferenceNode [
	| node analyzedNode |
	node := builder pointer: (builder literal: nil type: compilationTarget int32Type pointer) elementReferenceAt: (builder literalInteger: 1).
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isPointerElementReferenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerIntegerCasts [
	| uintPointerType voidPointerType |
	uintPointerType := compilationTarget uintPointerType.
	voidPointerType := compilationTarget voidType pointer.

	self assert: (self reinterpretAnalyzedCastNodeFrom: uintPointerType to: voidPointerType) isIntegerToPointerCastNode.
	self assert: (self reinterpretAnalyzedCastNodeFrom: voidPointerType to: uintPointerType) isPointerToIntegerCastNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerReinterpretCast [
	| voidPointerType uint8PointerType uint32PointerType constUInt8PointerType |
	voidPointerType := compilationTarget voidType pointer.
	constUInt8PointerType := compilationTarget uint8Type const pointer.
	uint8PointerType := compilationTarget uint8Type pointer.
	uint32PointerType := compilationTarget uint32Type pointer.

	self assert: (self reinterpretAnalyzedCastNodeFrom: uint8PointerType to: uint32PointerType) isPointerReinterpretCastNode.

	self assert: (self implicitAnalyzedCastNodeFrom: uint8PointerType to: voidPointerType) isPointerReinterpretCastNode.
	self should: [self implicitAnalyzedCastNodeFrom: constUInt8PointerType to: uint8PointerType] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: voidPointerType to: uint8PointerType] raise: Error.

	self assert: (self explicitAnalyzedCastNodeFrom: voidPointerType to: uint8PointerType) isPointerReinterpretCastNode.
	self should: [self explicitAnalyzedCastNodeFrom: uint8PointerType to: uint32PointerType] raise: Error.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerTypeConstruction [
	| node analyzedNode |
	node := builder unexpandedSend: (builder literalSymbol: #pointer)
		to: (builder identifier: #Int32)
		withArguments: #().
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLiteralValueNode.
	self assert: analyzedNode value isPointerType.
	self assert: analyzedNode type isMetaType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPrintfCall [
	| node analyzedNode |
	node := builder sequence: {
		self libcPrintfDeclarationNode.
		builder call: (builder identifier: #printf) arguments: { 
			builder literalString: 'Hello World:'.
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPrintfCallWithIntegerAndFloatArgument [
	| node analyzedNode |
	node := builder sequence: {
		self libcPrintfDeclarationNode.
		builder call: (builder identifier: #printf) arguments: { 
			builder literalString: 'Hello World: %d %f'.
			builder literalInteger: 42.
			builder literalFloat: 42.0.
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPrintfCallWithIntegerArgument [
	| node analyzedNode |
	node := builder sequence: {
		self libcPrintfDeclarationNode.
		builder call: (builder identifier: #printf) arguments: { 
			builder literalString: 'Hello World: %d'.
			builder literalInteger: 42.
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPutsCall [
	| node analyzedNode |
	node := builder sequence: {
		self libcPutsDefinitionNode.
		builder call: (builder identifier: #puts) arguments: { 
			builder literalString: 'Hello World'
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testQuasiQuoteLiteral [
	| node analyzedNode |
	node := builder quasiQuote: (builder literalInteger: 42).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isQuasiQuoteNode.
	self assert: analyzedNode type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testQuasiQuoteUnquoteQuoteLiteral [
	| node analyzedNode |
	node := builder quasiQuote: (builder quasiUnquote: (builder quote: (builder literalInteger: 42))).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isQuasiQuoteNode.
	self assert: analyzedNode type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testQuote [
	| node analyzedNode |
	node := builder quote: (builder literalInteger: 42).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isQuoteNode.
	self assert: analyzedNode type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testReturnMacroExpansion [
	| value node analyzedNode |
	value := builder literalInteger: 42.
	node := builder unexpandedSend: (builder literalSymbol: #return:)
		to: nil withArguments: {value}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isReturnStatementNode.
	self assert: analyzedNode expression equals: value.
	self assert: analyzedNode type isReturnType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testSequence [
	| node analyzedNode |
	node := builder sequence: { 
		builder literalInteger: 1.
		builder literalFloat: 42.
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode .
	self assert: analyzedNode elements size equals: 2.
	self assert: analyzedNode type isPrimitiveFloatType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testSequenceWithReturn [
	| node analyzedNode |
	node := builder sequence: { 
		builder literalInteger: 1.
		builder return: (builder literalInteger: 42).
		builder literalInteger: 30.
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode .
	self assert: analyzedNode elements size equals: 2.
	self assert: analyzedNode type isReturnType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testSignExtension [
	| int8Type int16Type int32Type int64Type uint16Type uint32Type uint64Type |
	int8Type := compilationTarget int8Type.
	int16Type := compilationTarget int16Type.
	int32Type := compilationTarget int32Type.
	int64Type := compilationTarget int64Type.
	uint16Type := compilationTarget uint16Type.
	uint32Type := compilationTarget uint32Type.
	uint64Type := compilationTarget uint64Type.
	
	self assert: (self implicitAnalyzedCastNodeFrom: int8Type to: int16Type) isSignExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int8Type to: uint16Type) isSignExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int16Type to: int32Type) isSignExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int16Type to: uint32Type) isSignExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int32Type to: int64Type) isSignExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: int32Type to: uint64Type) isSignExtensionCastNode.
	
	self assert: (self explicitAnalyzedCastNodeFrom: int8Type to: int16Type) isSignExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int8Type to: uint16Type) isSignExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: int32Type) isSignExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: uint32Type) isSignExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: int64Type) isSignExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: uint64Type) isSignExtensionCastNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableMutableAssignment [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: (builder identifier: #Int32) withInitialValue: nil)
			mutable.
		builder reference: (builder identifier: #x) assignValue: (builder literalInteger: 5).
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableMutableDefaultInitialValue [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: compilationTarget int32Type withInitialValue: nil)
			mutable.
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements first initialValue isNil.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.
	self assert: analyzedNode elements first binding isGlobalVariable.
	self assert: analyzedNode elements first binding isStatic.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableMutableReference [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableMutableReferenceAddress [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder unexpandedSend: (builder literalSymbol: #address)
			to: (builder identifier: #x)
			withArguments: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPointerType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableMutableReferenceExplicitLoad [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder referenceLoad: (builder identifier: #x)
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableMutableReferenceImplicitLoad [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder unexpandedSend: (builder literalSymbol: #+)
			to: (builder identifier: #x)
			withArguments: { 
			(builder literalInteger: 1)
		}
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableScopeReference [
	| node analyzedNode |
	node := builder lexicalScope: (builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder identifier: #x
	}).
	
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) equals: nil.
	self assert: analyzedNode isLexicalScopeNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode expression elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStaticLocalVariableScopeReferenceError [
	| node |
	node := builder sequence: {
			builder lexicalScope: (builder sequence: { 
				(builder defineLocalVariable: #x withValueType: nil withInitialValue:
				(builder literalInteger: 5))
				mutable.
		}) .
		builder identifier: #x
	}.
	self should: [ visitor visitNode: node ] raise: Error
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureBasicNewValue [
	| node structureBody analyzedNode |
	structureBody := builder sequence: {
		builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil.
	}.
	visitor visitNode: (builder defineStructureNamed: #TestStructure body: structureBody).

	node := builder unexpandedSend: (builder literalSymbol: #basicNewValue)
		to: (builder identifier: #TestStructure) withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLiteralValueNode.
	self assert: analyzedNode type isStructureType.
	
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #struct.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isStructureType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureDeclarationNode [
	| node analyzedNode |
	node := builder declareStructure: #Test.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isStructureType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureDefinitionBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #struct.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isStructureType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureDefinitionBuilderWithOneFieldExpansion [
	| node analyzedNode fieldNode structureType |
	fieldNode := builder identifier: #field.
	fieldNode := builder unexpandedSend: (builder literalSymbol: #i) to: fieldNode withArguments: #().
	fieldNode := builder unexpandedSend: (builder literalSymbol: #type:) to: fieldNode
		withArguments: {builder identifier: #Int32}.
	
	node := builder identifier: #struct.
	node := builder unexpandedSend: (builder literalSymbol: #Test) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: { fieldNode }
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	structureType := analyzedNode binding.
	self assert: structureType isNotNil.
	self assert: structureType isStructureType.
	self assert: structureType fields size equals: 1.
	self assert: structureType fields first valueType equals: compilationTarget int32Type.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureEmptyDefinitionNode [
	| node body analyzedNode |
	body := builder sequence: #().
	node := builder defineStructureNamed: #Test body: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isStructureType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureMessage [
	| node structureBody analyzedNode structure method methodBody |
	structureBody := builder sequence: {
		(builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil).
		
		builder messageSelector: #value arguments: #() returnType: (builder identifier: #Int32) definitionBody: (builder identifier: #intField)
	}.
	visitor visitNode: (builder defineStructureNamed: #TestStructure body: structureBody).

	node := builder unexpandedSend: (builder literalSymbol: #newValue)
		to: (builder identifier: #TestStructure) withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #value)
		to: node withArguments: #().

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveIntegerType.
	
	structure := scope lookupSymbolRecursively: #TestStructure ifAbsent: [nil].
	self assert: structure isStructureType.
	
	method := structure lookupLocalOverloadedSelector: #value.
	method ensureSemanticAnalysis.
	methodBody := method analyzedBody.
	self assert: methodBody isReferenceLoadNode.
	self assert: methodBody reference isGetFieldReferenceNode.
	self assert: methodBody reference aggregate isVariableReferenceNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureNewValue [
	| node structureBody analyzedNode |
	structureBody := builder sequence: {
		builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil.
	}.
	visitor visitNode: (builder defineStructureNamed: #TestStructure body: structureBody).

	node := builder unexpandedSend: (builder literalSymbol: #newValue)
		to: (builder identifier: #TestStructure) withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type withoutReferences isStructureType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructurePublicFieldReferenceGetter [
	| node structureBody analyzedNode |
	structureBody := builder sequence: {
		(builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil)
			public.
	}.
	visitor visitNode: (builder defineStructureNamed: #TestStructure body: structureBody).

	node := (builder defineLocalVariable: #testStructure withValueType: (builder identifier: #TestStructure) withInitialValue: nil) mutable.
	visitor visitNode: node.
	
	node := builder unexpandedSend: (builder literalSymbol: #intField)
		to: (builder identifier: #testStructure) withArguments: #().

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructurePublicFieldValueGetter [
	| node structureBody analyzedNode |
	structureBody := builder sequence: {
		(builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil)
			public.
	}.
	visitor visitNode: (builder defineStructureNamed: #TestStructure body: structureBody).

	node := builder unexpandedSend: (builder literalSymbol: #newValue)
		to: (builder identifier: #TestStructure) withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #intField)
		to: node withArguments: #().

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructurePublicFieldValueSetter [
	| node structureBody analyzedNode |
	structureBody := builder sequence: {
		(builder defineField: #intField withValueType: (builder identifier: #Int32) withInitialValue: nil)
			public.
	}.
	visitor visitNode: (builder defineStructureNamed: #TestStructure body: structureBody).

	node := builder unexpandedSend: (builder literalSymbol: #newValue)
		to: (builder identifier: #TestStructure) withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #intField:)
		to: node withArguments: {builder literalInteger: 42}.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isStructureType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureWithOneFieldDefinitionNode [
	| node body analyzedNode structure |
	body := builder sequence: {
		builder defineField: #i withValueType: (builder identifier: #Int32) withInitialValue: nil
	}.
	node := builder defineStructureNamed: #Test body: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDefinitionNode.
	
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	structure := analyzedNode binding.
	self assert: structure isNotNil.
	self assert: structure isStructureType.

	self assert: (structure lookupSymbol: #i) isNotNil.
	self assert: structure instanceSize equals: 4	.
	self assert: structure instanceAlignment equals: 4.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testStructureWithTwoFieldsDefinitionNode [
	| node body analyzedNode structure |
	body := builder sequence: {
		builder defineField: #i withValueType: (builder identifier: #Int32) withInitialValue: nil.
		builder defineField: #f withValueType: (builder identifier: #Float32) withInitialValue: nil.
	}.
	node := builder defineStructureNamed: #Test body: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isStructureDefinitionNode.
	
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	structure := analyzedNode binding.
	self assert: structure isNotNil.
	self assert: structure isStructureType.

	self assert: (structure lookupSymbol: #i) isNotNil.
	self assert: (structure lookupSymbol: #f) isNotNil.
	self assert: structure instanceSize equals: 8.
	self assert: structure instanceAlignment equals: 4.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testTemplateDefinition [
	| arguments body node analyzedNode binding |
	arguments := {
		builder argument: #T type: (builder identifier: #Type).
	}.
	body := builder defineStructureNamed: #_ body: ( 
		builder defineField: #value withValueType: (builder identifier: #T) withInitialValue: nil
	).
	node := builder defineTemplate: #ValueHolder arguments: arguments body: body.
	analyzedNode := visitor visitNode: node.
	
	self assert: analyzedNode ~~ node.
	self assert: analyzedNode isTemplateDefinitionNode.
	self assert: analyzedNode name equals: #ValueHolder.
	self assert: analyzedNode type isTemplateType.
	self assert: analyzedNode type isTypeTemplateType.
	binding := analyzedNode binding.
	
	self assert: binding isNotNil.
	self assert: binding isTemplate.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testTemplateInstance [
	| arguments body node analyzedNode structureType |
	arguments := {
		builder argument: #T type: (builder identifier: #Type).
	}.
	body := builder defineStructureNamed: #_ body: ( 
		builder defineField: #value withValueType: (builder identifier: #T) withInitialValue: nil
	).
	node := builder sequence: {
		builder defineTemplate: #ValueHolder arguments: arguments body: body.
		builder unexpandedCall: (builder identifier: #ValueHolder) withArguments: { 
			builder identifier: #Int32
		}
	}.
	analyzedNode := visitor visitNode: node.
	
	self assert: analyzedNode ~~ node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isMetaType.
	structureType := analyzedNode type instanceType.
	self assert: structureType isStructureType.
	self assert: structureType type instanceType equals: structureType.
	self assert: structureType fields size equals: 1.
	self assert: structureType fields first valueType equals: compilationTarget int32Type.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testTraitDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #trait.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isTraitDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isTraitType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testTraitDefinitionBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #trait.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isTraitDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isTraitType.
	self assert: analyzedNode binding type instanceType equals: analyzedNode binding.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testTruncate [
	| int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type |
	int8Type := compilationTarget int8Type.
	int16Type := compilationTarget int16Type.
	int32Type := compilationTarget int32Type.
	int64Type := compilationTarget int64Type.
	uint8Type := compilationTarget uint8Type.
	uint16Type := compilationTarget uint16Type.
	uint32Type := compilationTarget uint32Type.
	uint64Type := compilationTarget uint64Type.
	
	self assert: (self explicitAnalyzedCastNodeFrom: int64Type to: int8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: int8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: int8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int64Type to: uint8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int32Type to: uint8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: int16Type to: uint8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint64Type to: int8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: int8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: int8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint64Type to: uint8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: uint8Type) isTruncateCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: uint8Type) isTruncateCastNode.

	self should: [self implicitAnalyzedCastNodeFrom: int64Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int32Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int16Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int64Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int32Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: int16Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint64Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint32Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint16Type to: int8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint64Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint32Type to: uint8Type] raise: Error.
	self should: [self implicitAnalyzedCastNodeFrom: uint16Type to: uint8Type] raise: Error.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testUnionDeclarationBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #union.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isUnionDeclarationNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isUnionType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testUnionDefinitionBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #union.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #definition:) to: node withArguments: {
		builder sequence: #()
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isUnionDefinitionNode.
	self assert: (scope lookupSymbolRecursively: #x ifAbsent: [nil]) isNotNil.
	self assert: analyzedNode binding isNotNil.
	self assert: analyzedNode binding isUnionType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testUnionWithTwoFieldsDefinitionNode [
	| node body analyzedNode structure |
	body := builder sequence: {
		builder defineField: #i withValueType: (builder identifier: #Int32) withInitialValue: nil.
		builder defineField: #f withValueType: (builder identifier: #Float32) withInitialValue: nil.
	}.
	node := builder defineUnionNamed: #Test body: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isUnionDefinitionNode.
	
	self assert: (scope lookupSymbolRecursively: #Test ifAbsent: [nil]) isNotNil.
	structure := analyzedNode binding.
	self assert: structure isNotNil.
	self assert: structure isUnionType.

	self assert: (structure lookupSymbol: #i) isNotNil.
	self assert: (structure lookupSymbol: #f) isNotNil.
	self assert: structure instanceSize equals: 4.
	self assert: structure instanceAlignment equals: 4.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testVariableReference [
	| node analyzedNode |
	node := builder sequence: { 
		builder defineLocalVariable: #x withValueType: nil withInitialValue: (builder literalInteger: 5).
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testVectorConstruction [
	| node one two vectorType analyzedNode |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	vectorType := builder identifier: #Float32x2.
	node := builder constructVector: vectorType withElements: { one . two }.
	analyzedNode := visitor visitNode: node.
	
	self assert: analyzedNode isVectorConstructionNode.
	self assert: analyzedNode vectorType isPrimitiveVectorType.
	self assert: analyzedNode vectorType elementType isPrimitiveFloatType.
	self assert: analyzedNode vectorType elements equals: 2.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testVectorMatrixMultiplication [
	| node leftMatrix rightMatrix analyzedNode |
	leftMatrix := builder constructVector: (builder identifier: #Float32x2) withElements: {
		builder literalFloat: 0.0.
		builder literalFloat: 0.0.
	}.
	rightMatrix := builder constructMatrix: (builder identifier: #Float32x2x2) withColumns: {leftMatrix . leftMatrix}.
	
	node := builder matrix: leftMatrix multiplicationWith: rightMatrix.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMatrixMultiplicationOperationNode.
	self assert: analyzedNode type isPrimitiveVectorType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testZeroExtension [
	| int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type |
	int16Type := compilationTarget int16Type.
	int32Type := compilationTarget int32Type.
	int64Type := compilationTarget int64Type.
	uint8Type := compilationTarget uint8Type.
	uint16Type := compilationTarget uint16Type.
	uint32Type := compilationTarget uint32Type.
	uint64Type := compilationTarget uint64Type.
	
	self assert: (self implicitAnalyzedCastNodeFrom: uint8Type to: int16Type) isZeroExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint8Type to: uint16Type) isZeroExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint16Type to: int32Type) isZeroExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint16Type to: uint32Type) isZeroExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint32Type to: int64Type) isZeroExtensionCastNode.
	self assert: (self implicitAnalyzedCastNodeFrom: uint32Type to: uint64Type) isZeroExtensionCastNode.
	
	self assert: (self explicitAnalyzedCastNodeFrom: uint8Type to: int16Type) isZeroExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint8Type to: uint16Type) isZeroExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: int32Type) isZeroExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint16Type to: uint32Type) isZeroExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: int64Type) isZeroExtensionCastNode.
	self assert: (self explicitAnalyzedCastNodeFrom: uint32Type to: uint64Type) isZeroExtensionCastNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testZeroFunctionDefinition [
	| node analyzedNode body concreteMethod |
	body := builder literalInteger: 0.
	node := builder functionNamed: #zero arguments: #() returnType: compilationTarget int32Type definitionBody: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]
