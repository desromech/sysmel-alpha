Class {
	#name : #MbndSysmelLanguageSemanticEvaluationTest,
	#superclass : #MbndSysmelLanguageTestCommon,
	#category : #'SysmelLanguage-Sysmel-Tests-Parser'
}

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testMetaMacroMethod [
	self evaluateSource: '
class TestClass definition: {
    meta macro method makeMethod: methodName with: body := ``{
        method `,(methodName asLiteralSymbolNodeFor: Compiler compilationTarget) => Boolean8 := `,body
    }.

	makeMethod: returnAlwaysTrue with: true.	
	makeMethod: returnAlwaysFalse with: false.	
	
}.'.
	self assert: (self evaluateSource: 'TestClass newValue returnAlwaysTrue') unwrapMbndValue.
	self deny: (self evaluateSource: 'TestClass newValue returnAlwaysFalse') unwrapMbndValue.

]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testNonCopyable [
	self evaluateSource: '
		struct NonCopyableStruct definition: {
			SelfType makeNonCopyable.
		
			public field someField type: Int32.
		}.
		
		function makeNonCopyable(v: Int32) => NonCopyableStruct
			:= NonCopyableStruct basicNewValue someField: v; yourself.
		function makeNonCopyable() => NonCopyableStruct
			:= NonCopyableStruct basicNewValue.
	'.
	semanticModule finishSemanticAnalysis
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testNonCopyableError [
	self should: [self evaluateSource: '
		struct NonCopyableStruct definition: {
			SelfType makeNonCopyable.
		
			public field someField type: Int32.
		}.
		
		function withError(r: NonCopyableStruct ref) => NonCopyableStruct
			:= r
	'.
	semanticModule finishSemanticAnalysis
	] raise: MbndSemanticError
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testNonCopyableError2 [
	self should: [self evaluateSource: '
		struct NonCopyableStruct definition: {
			SelfType makeNonCopyable.
		
			public field someField type: Int32.
		}.
		
		function withError(r: NonCopyableStruct ref) => Int32 :=
		{
			let x mutable := r.
			x someField
		}
	'.
	semanticModule finishSemanticAnalysis
	] raise: MbndSemanticError
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testNonCopyableError3 [
	self should: [self evaluateSource: '
		struct NonCopyableStruct definition: {
			SelfType makeNonCopyable.
		
			public field someField type: Int32.
		}.
		
		function withError(r: NonCopyableStruct ref) => Int32 :=
		{
			let x mutable type: NonCopyableStruct.
			x := r.
			x someField
		}
	'.
	semanticModule finishSemanticAnalysis
	] raise: MbndSemanticError
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testPredicateTypeConcept [
	| concept testType |
	concept := (self evaluateSource: 'concept AnyTypeConcept predicate: {:type | true}') unwrapMbndValue.
	testType := semanticModule compilationTarget int32Type.
	self assert: concept isPredicatedTypeConcept.
	self assert: (concept doesTypeComplyWithConcept: testType).
		
	concept := (self evaluateSource: 'concept AnyTypeConcept2 := {:type | true}') unwrapMbndValue.
	self assert: concept isPredicatedTypeConcept.
	self assert: (concept doesTypeComplyWithConcept: testType).

]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testTypeConceptEqualable [
	self evaluateSource: '
	concept Equalable := {:type | type canUnderstand: #= }.
	struct TestStruct definition: { }.
'.
	self assert: (self evaluateSource: 'Equalable doesTypeComplyWithConcept: Int32') unwrapMbndValue.
	self deny: (self evaluateSource: 'Equalable doesTypeComplyWithConcept: TestStruct') unwrapMbndValue.
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testTypeConceptHashKey [
	self evaluateSource: '
	concept HashKey := {:type | type canUnderstandAll: #(= hash) }.
	Int32 macro method hash := self.
	struct TestStruct definition: { }.
'.
	self assert: (self evaluateSource: 'HashKey doesTypeComplyWithConcept: Int32') unwrapMbndValue.
	self deny: (self evaluateSource: 'HashKey doesTypeComplyWithConcept: TestStruct') unwrapMbndValue.
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testTypeConceptIfTypeCompliesElse [
	| selectedType |
	selectedType := (self evaluateSource: '
	concept PointerSized predicate: {:type | type instanceSize = Compiler compilationTarget pointerSize}.
		PointerSized ifType: UInt32 complies: UInt32 else: UInt64
	') unwrapMbndValue.
	self assert: selectedType instanceSize equals: semanticModule compilationTarget pointerSize
]
