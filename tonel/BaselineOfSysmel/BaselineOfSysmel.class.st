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
		spec baseline: 'Slovim' with: [
				spec
					repository: 'github://ronsaldo/slovim/tonel' ].
		spec baseline: 'Phanide' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].

		spec
			package: 'Sysmel-Parser' with: [
				spec requires: #('PetitParser' 'Sysmel-Metamodel')
			].
		spec
			package: 'Sysmel-Metamodel' with: [
				spec requires: #('Slovim')
			].
		spec
			package: 'Sysmel-Tests' with: [
				spec requires: #('Sysmel-Parser' 'Sysmel-Metamodel')
			].
		spec
			package: 'Sysmel-Phanide' with: [
				spec requires: #('Sysmel-Parser' 'Sysmel-Metamodel' 'Phanide')
			].
	].
]
