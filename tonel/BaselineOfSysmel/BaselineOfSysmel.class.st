Class {
	#name : #BaselineOfSysmel,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmel
}

{ #category : #baselines }
BaselineOfSysmel >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'
		].
		spec
			package: 'Sysmel-Parser' with: [
				spec requires: #('PetitParser')
			].
		spec
			package: 'Sysmel-Metamodel' with: [
				spec requires: #('Sysmel-Parser')
			].
	].
]
