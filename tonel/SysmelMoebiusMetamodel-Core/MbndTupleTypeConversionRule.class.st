Class {
	#name : #MbndTupleTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndTupleTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| sourceExpression targetType |
	sourceExpression := node expression.
	targetType := node type.
	self assert: targetType isTupleType.
	sourceExpression isTupleNode ifTrue: [
		self assert: sourceExpression elements size = targetType elements size.
		^ analyzer analyzeNodeIfNeeded: (MbndAstTupleNode new
			position: node;
			elements: (sourceExpression elements collectWithIndex: [:sourceElement :index |
				analyzer addImplicitCastFor: (analyzer analyzeNodeIfNeeded: sourceElement) to: (targetType elements at: index)
			]);
			yourself)
	].

	sourceExpression isLiteralValueNode ifTrue: [
		self assert: sourceExpression value size = targetType elements size.
		^ analyzer analyzeNodeIfNeeded: (MbndAstTupleNode new
			position: node;
			elements: (sourceExpression value collectWithIndex: [:sourceElement :index |
				| elementLiteral |
				elementLiteral := MbndAstLiteralValueNode new
					position: sourceExpression;
					value: sourceElement;
					type: (sourceExpression type elements at: index);
					yourself.
				analyzer addImplicitCastFor: elementLiteral to: (targetType elements at: index)
			]);
			yourself)
	].

	self halt
]
