Class {
	#name : #MbndLiteralStringToCStringConversionRule,
	#superclass : #MbndLiteralValueTypeChangeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #acccessing }
MbndLiteralStringToCStringConversionRule >> conversionCost [
	^ super conversionCost + 1
]
