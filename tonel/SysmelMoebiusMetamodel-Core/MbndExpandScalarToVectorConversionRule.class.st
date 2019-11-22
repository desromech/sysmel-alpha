Class {
	#name : #MbndExpandScalarToVectorConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndExpandScalarToVectorConversionRule >> specificCastNodeClass [
	^ MbndAstExpandScalarToVectorCastNode
]
