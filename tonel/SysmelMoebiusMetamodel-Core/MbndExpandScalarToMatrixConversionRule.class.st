Class {
	#name : #MbndExpandScalarToMatrixConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndExpandScalarToMatrixConversionRule >> specificCastNodeClass [
	^ MbndAstExpandScalarToMatrixCastNode
]
