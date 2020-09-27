Class {
	#name : #SysmelNativeType,
	#superclass : #Object,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
SysmelNativeType class >> instanceAlignment [
	self subclassResponsibility
]

{ #category : #sizes }
SysmelNativeType class >> instanceSize [
	self subclassResponsibility
]

{ #category : #testing }
SysmelNativeType class >> isAbstract [
	^ self == SysmelNativeType
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> validateExplicitCastOfValue: aValue [
	^ self validateImplicitCastOfValue: aValue
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> validateImplicitCastOfValue: aValue [
	self assert: aValue class == self.
	^ aValue
]
