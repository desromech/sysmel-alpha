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
		spec project: 'Slovim' with: [
				spec
					className: #ConfigurationOfSlovim;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/Slovim/main/' ].

		spec
			package: 'Sysmel-Parser' with: [
				spec requires: #('PetitParser' 'Sysmel-Metamodel')
			].
		spec
			package: 'Sysmel-Metamodel' with: [
				spec requires: #('Slovim')
			].
	].
]
