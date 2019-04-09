Class {
	#name : #MbndAbstractVariableMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'initialValueNode',
		'valueType'
	],
	#category : #'MoebiusBandMetamodel-Core-MetaBuilder'
}

{ #category : #definition }
MbndAbstractVariableMetaBuilder >> assignValue: newInitialValueNode [
	initialValueNode := currentAnalyzer visitNode: newInitialValueNode.
	valueType ifNil: [
		valueType := initialValueNode type inferValueTypeForNode: initialValueNode inScope: currentAnalyzer scope.
	].

	self assert: valueType isNotNil.
	initialValueNode := currentAnalyzer addImplicitCastFor: initialValueNode to: valueType
]

{ #category : #mutability }
MbndAbstractVariableMetaBuilder >> mutable [

]

{ #category : #accessing }
MbndAbstractVariableMetaBuilder >> type: typeExpression [
	initialValueNode ifNotNil: [ 
		currentAnalyzer error: 'The variable type must be specified before the initial value.' at: typeExpression
	].

	valueType := currentAnalyzer evaluateTypeExpression: typeExpression.

]
