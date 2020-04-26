Class {
	#name : #MbndTupleTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndTupleTypeConversionRule >> postProcessCastNode: node withAnalyzer: analyzer [
	| sourceExpression targetType tupleElements castedTupleElements |
	sourceExpression := node expression.
	targetType := node type.
	self assert: targetType isTupleType.
	sourceExpression isTupleNode ifTrue: [
		self assert: sourceExpression elements size = targetType elements size.
		^ analyzer analyzeNodeIfNeeded: (MbndAstTupleNode new
			position: node;
			elements: (sourceExpression elements collectWithIndex: [:sourceElement :index |
				analyzer addImplicitCastFor: sourceElement to: (targetType elements at: index)
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

	tupleElements := analyzer visitSplicingTupleNode: sourceExpression.
	castedTupleElements := tupleElements collectWithIndex: [ :splicedTupleElement :index |
		| targetElementType |
		targetElementType := targetType elements at: index.
		node isImplicitCastNode ifTrue: [
			analyzer addImplicitCastFor: splicedTupleElement to: targetElementType
		] ifFalse: [ 
			self assert: node isExplicitCastNode.
			analyzer visitNode: (MbndAstImplicitCastNode new
				position: node;
				expression: splicedTupleElement;
				targetType: targetElementType;
				yourself)
		]
	].

	^ MbndAstTupleNode new
		position: node;
		elements: castedTupleElements;
		type: targetType;
		yourself
]
