(#(windows uwp) includes: self platform name) ifTrue: [
    self externalLibrary: 'zlib' buildWith: [:builder |
        builder
            sourceDirectory: 'zlib-1.2.11';
            useSeparateBuildDirectory;
            useCMakeReleaseMode;
            configureWithCMake;
            buildWithCMake;
            installWithCMake
    ].
].


self platform name selectCase: {
    #linux -> [
        self importLibrary: 'z' fromDebianPackage: 'zlib1g-dev'.
    ].
    [true] -> []
}.
