Class {
	#name : #MbndCompileTimeEvaluationTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-Module'
}

{ #category : #running }
MbndCompileTimeEvaluationTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testAddInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #+) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 4.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testDivideInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #/) to:
		(builder literalInteger: -6) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerBitAnd [
	| ast result |
	ast := builder send: (builder literalSymbol: #&) to:
		(builder literalInteger: 16rFF) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerBitAnd2 [
	| ast result |
	ast := builder send: (builder literalSymbol: #bitAnd:) to:
		(builder literalInteger: 16rFF) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerBitOr [
	| ast result |
	ast := builder send: (builder literalSymbol: #|) to:
		(builder literalInteger: 16r0) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerBitOr2 [
	| ast result |
	ast := builder send: (builder literalSymbol: #bitOr:) to:
		(builder literalInteger: 16r0) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerEquals [
	| ast result |
	ast := builder send: (builder literalSymbol: #=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerGreaterOrEqual [
	| ast result |
	ast := builder send: (builder literalSymbol: #>=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerGreaterThan [
	| ast result |
	ast := builder send: (builder literalSymbol: #>) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerIdentityEquals [
	| ast result |
	ast := builder send: (builder literalSymbol: #==) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerIdentityNotEquals [
	| ast result |
	ast := builder send: (builder literalSymbol: #~~) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerLessOrEqual [
	| ast result |
	ast := builder send: (builder literalSymbol: #<=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerLessThan [
	| ast result |
	ast := builder send: (builder literalSymbol: #<) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testIntegerNotEquals [
	| ast result |
	ast := builder send: (builder literalSymbol: #~=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isPrimitiveBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testLexicallyScopedLiteral [
	| ast result |
	ast := (builder literalInteger: 42) lexicallyScoped.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testLiteralInteger [
	| ast result |
	ast := builder literalInteger: 42.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testMultiplyInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #*) to:
		(builder literalInteger: 2) withArguments: {
			builder literalInteger: -3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -6.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testNegateInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #negated) to:
		(builder literalInteger: 42) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -42.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testReturn [
	| ast result |
	ast := builder sequence: {
		builder return: (builder literalInteger: 42).
		builder literalInteger: 0
	}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSequenceOfLiterals [
	| ast result |
	ast := builder sequence: {
		builder literalInteger: 1.
		builder literalInteger: 2.
		builder literalInteger: 42.
	}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSequenceOfSequenceLiterals [
	| ast result |
	ast := builder sequence: {
		builder sequence: { 
			builder literalInteger: 1.
			builder literalInteger: 2.
		}.
		builder literalInteger: 42.
	}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result unwrapMbndValue equals: 42
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSignedIntegerBitInvert [
	| ast result |
	ast := builder send: (builder literalSymbol: #bitInvert) to:
		(builder literalInteger: 16r0) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -1.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testSubtractInteger [
	| ast result |
	ast := builder send: (builder literalSymbol: #-) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedAddInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #+) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 4.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedBitAnd [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #&) to:
		(builder literalInteger: 16rFF) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedBitAnd2 [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #bitAnd:) to:
		(builder literalInteger: 16rFF) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedBitNot [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #bitInvert) to:
		(builder literalInteger: 16r0) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -1.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedBitOr [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #|) to:
		(builder literalInteger: 16r0) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedBitOr2 [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #bitOr:) to:
		(builder literalInteger: 16r0) withArguments: {
			builder literalInteger: 42
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 42.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedDivideInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #/) to:
		(builder literalInteger: -6) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerEqual [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerEqualIdentity [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #==) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerGreater [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #>) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerGreaterOrEqual [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #>=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerLess [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #<) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerLessOrEqual [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #<=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: true.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerNotEqual [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #~=) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedIntegerNotEqualIdentity [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #~~) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 1
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: false.
	self assert: result type isLiteralBooleanType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedMultiplyInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #*) to:
		(builder literalInteger: 2) withArguments: {
			builder literalInteger: -3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -6.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedNegateInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #negated) to:
		(builder literalInteger: 42) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -42.
	self assert: result type isLiteralIntegerType
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnexpandedSubtractInteger [
	| ast result |
	ast := builder unexpandedSend: (builder literalSymbol: #-) to:
		(builder literalInteger: 1) withArguments: {
			builder literalInteger: 3
		}.
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: -2.
	self assert: result type isLiteralIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnsignedIntegerBitInvert [
	| ast result |
	ast := builder send: (builder literalSymbol: #bitInvert) to:
		(builder literal: 0 type: module compilationTarget uint32Type) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 16rFFFFFFFF.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnsignedIntegerHighBit [
	| ast result |
	ast := builder send: (builder literalSymbol: #highBit) to:
		(builder literal: 3 type: module compilationTarget uint32Type) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 2.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndCompileTimeEvaluationTest >> testUnsignedIntegerLowBit [
	| ast result |
	ast := builder send: (builder literalSymbol: #lowBit) to:
		(builder literal: 3 type: module compilationTarget uint32Type) withArguments: #().
	result := module analyzeAndEvaluateAST: ast.
	
	self assert: result value equals: 1.
	self assert: result type isPrimitiveIntegerType.
]
