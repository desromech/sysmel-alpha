Class {
	#name : #MbndLiteralStringToCStringBytePointerConversionRule,
	#superclass : #MbndLiteralStringToCStringConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #acccessing }
MbndLiteralStringToCStringBytePointerConversionRule >> conversionCost [
	^ super conversionCost + 1
]
