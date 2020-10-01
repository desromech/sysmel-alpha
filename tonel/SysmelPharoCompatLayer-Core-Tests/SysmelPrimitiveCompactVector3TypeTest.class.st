Class {
	#name : #SysmelPrimitiveCompactVector3TypeTest,
	#superclass : #SysmelPrimitiveVector3TypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveCompactVector3TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveCompactVector3TypeTest
]

{ #category : #running }
SysmelPrimitiveCompactVector3TypeTest >> setUp [
	super setUp.
	Vector3 := CompactVector3.
]
