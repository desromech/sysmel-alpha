Class {
	#name : #SysmelPrimitiveCompactVector3Type,
	#superclass : #SysmelPrimitiveVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
SysmelPrimitiveCompactVector3Type class >> instanceAlignment [
	^ self elementType instanceAlignment
]

{ #category : #testing }
SysmelPrimitiveCompactVector3Type class >> isAbstract [
	^ self == SysmelPrimitiveCompactVector3Type
]
