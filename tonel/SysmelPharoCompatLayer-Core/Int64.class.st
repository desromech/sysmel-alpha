Class {
	#name : #Int64,
	#superclass : #SysmelPrimitiveSignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Int64 class >> instanceAlignment [
	^ 8
]

{ #category : #sizes }
Int64 class >> instanceSize [
	^ 8
]
