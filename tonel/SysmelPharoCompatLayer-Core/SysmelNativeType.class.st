Class {
	#name : #SysmelNativeType,
	#superclass : #Object,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
SysmelNativeType class >> alignedInstanceSize [
	^ self instanceSize alignedTo: self instanceAlignment
]

{ #category : #'type composition' }
SysmelNativeType class >> array [
	^ self array: 0
]

{ #category : #'type composition' }
SysmelNativeType class >> array: elements [
	^ SysmelNativeTypeCache arrayOf: self elements: elements
]

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

{ #category : #testing }
SysmelNativeType class >> isAbstractClassType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isAggregateType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isAggregateTypeWithFields [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isArrayType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isClassType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isInterfaceType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveBooleanType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveCharacterType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveFloatType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveIntegerType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveMatrixType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveSignedIntegerType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveUnsignedIntegerType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveVectorType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isStructureType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isSysmelNativeType [
	^ true
]

{ #category : #testing }
SysmelNativeType class >> isUnionType [
	^ false
]

{ #category : #'instance creation' }
SysmelNativeType class >> named: aSymbol [
	^ SysmelTypedSlot named: aSymbol for: self
]

{ #category : #'instance creation' }
SysmelNativeType class >> newFromBytes: aByteArray [
	^ self newFromBytes: aByteArray position: 1
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ self basicNew readBytesFrom: aByteArray position: byteArrayPosition; yourself
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> storeValue: value bytesIn: aByteArray [
	^ self storeValue: value bytesIn: aByteArray position: 1
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	^ value storeBytesIn: aByteArray position: byteArrayPosition
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

{ #category : #'memory access' }
SysmelNativeType >> readBytesFrom: aByteArray [
	self readBytesFrom: aByteArray position: 1
]

{ #category : #'memory access' }
SysmelNativeType >> readBytesFrom: aByteArray position: byteArrayPosition [
	^ self class aggregateLayout readBytesFrom: aByteArray position: byteArrayPosition intoInstance: self
]

{ #category : #'memory access' }
SysmelNativeType >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	^ self subclassResponsibility
]

{ #category : #'memory access' }
SysmelNativeType >> storeBytesIn: aByteArray [
	^ self storeBytesIn: aByteArray position: 1
]

{ #category : #'memory access' }
SysmelNativeType >> storeBytesIn: aByteArray position: byteArrayPosition [
	^ self subclassResponsibility
]
