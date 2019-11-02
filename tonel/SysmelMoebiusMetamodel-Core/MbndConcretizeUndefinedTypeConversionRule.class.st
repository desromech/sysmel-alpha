Class {
	#name : #MbndConcretizeUndefinedTypeConversionRule,
	#superclass : #MbndSpecificCastNodeRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #hooks }
MbndConcretizeUndefinedTypeConversionRule >> specificCastNodeClass [
	^ MbndAstConcretizeUndefinedValueCastNode
]
