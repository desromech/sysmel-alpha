Class {
	#name : #MbndSlovimFunctionPatternMatchingBindingCodeGenerator,
	#superclass : #MbndSlovimFunctionPatternMatchingTestingCodeGenerator,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> andNextPatternResult: nextBlock [
	^ nextBlock value
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> applyNextPattern: nextPattern to: nextMatchedValueBlock [
	functionCodeGenerator generatePattern: nextPattern matchingWithValue: nextMatchedValueBlock value
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> generateTestingExpressionOf: node [
	"Nothing is required here"
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> visitPatternMatchingIntervalPatternNode: node [
	"Nothing required here"
	^ nil
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> visitPatternMatchingLiteralValuePatternNode: node [
	"Nothing required here"
	^ nil
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> visitPatternMatchingSameValuePatternNode: node [
	"Nothing required here"
	^ nil
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> visitPatternMatchingSetPatternNode: node [
	"Nothing required here"
	^ nil
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> visitPatternMatchingVariantTypeSelectionPatternNode: node [
	"Nothing required here"
	^ nil
]
