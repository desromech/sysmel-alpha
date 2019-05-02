Class {
	#name : #MbndReinterpretPointerTypeConversionRule,
	#superclass : #MbndIdentityTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #visiting }
MbndReinterpretPointerTypeConversionRule >> accept: aVisitor [
	^ aVisitor visitReinterpretPointerTypeConversionRule: self
]
