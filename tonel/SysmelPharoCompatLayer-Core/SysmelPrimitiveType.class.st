Class {
	#name : #SysmelPrimitiveType,
	#superclass : #SysmelNativeType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveType class >> isAbstract [
	^ self == SysmelPrimitiveType
]
