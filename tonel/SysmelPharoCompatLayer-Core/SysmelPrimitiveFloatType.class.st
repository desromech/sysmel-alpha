Class {
	#name : #SysmelPrimitiveFloatType,
	#superclass : #SysmelPrimitiveNumberType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #constants }
SysmelPrimitiveFloatType class >> halfPi [
	^ Float halfPi
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> infinity [
	^ Float infinity
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> infinityOrMaxValue [
	^ Float infinity
]

{ #category : #testing }
SysmelPrimitiveFloatType class >> isAbstract [
	^ self == SysmelPrimitiveFloatType
]

{ #category : #testing }
SysmelPrimitiveFloatType class >> isPrimitiveFloatType [
	^ true
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> negativeInfinity [
	^ Float negativeInfinity
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> negativeInfinityOrMinValue [
	^ Float negativeInfinity
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> one [
	^ 1.0
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> ones [
	^ 1.0
]

{ #category : #constants }
SysmelPrimitiveFloatType class >> pi [
	^ Float pi
]

{ #category : #constants }
SysmelPrimitiveFloatType class >> twoPi [
	^ Float twoPi
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveFloatType class >> validateImplicitCastOfValue: aValue [
	self assert: aValue isNumber.
	^ aValue asFloat
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> zero [
	^ 0.0
]

{ #category : #construction }
SysmelPrimitiveFloatType class >> zeros [
	^ 0.0
]
