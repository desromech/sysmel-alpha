Class {
	#name : #UInt64,
	#superclass : #SysmelPrimitiveIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
UInt64 class >> instanceAlignment [
	^ 8
]

{ #category : #sizes }
UInt64 class >> instanceSize [
	^ 8
]
