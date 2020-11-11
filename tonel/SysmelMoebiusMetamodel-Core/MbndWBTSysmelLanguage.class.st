Class {
	#name : #MbndWBTSysmelLanguage,
	#superclass : #MbndWBTModuleLanguage,
	#category : #'SysmelMoebiusMetamodel-Core-WBT'
}

{ #category : #testing }
MbndWBTSysmelLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelLanguage >> handlesFileExtension: aFileExtension [
	^ aFileExtension = 'sysmel'
]
