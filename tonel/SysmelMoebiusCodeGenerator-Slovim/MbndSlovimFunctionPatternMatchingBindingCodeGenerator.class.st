Class {
	#name : #MbndSlovimFunctionPatternMatchingBindingCodeGenerator,
	#superclass : #MbndSlovimFunctionPatternMatchingTestingCodeGenerator,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> applyNextPattern: nextPattern to: nextMatchedValue [
	functionCodeGenerator generatePattern: nextPattern matchingWithValue: nextMatchedValue
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionPatternMatchingBindingCodeGenerator >> buildAndingTowerWith: aBlock [
	aBlock value.
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
