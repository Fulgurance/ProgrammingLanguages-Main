class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "src"
        super
    end
    
    def build
        super

        runFile(file:       "make.bash",
                path:       buildDirectoryPath,
                environment:    {   "GOARCH" => "amd64",
                                    "GOAMD64" => "v1",
                                    "GOROOT_FINAL" => "/usr/lib/go",
                                    "GOTOOLCHAIN" => "local",
                                    "PATH" => "#{workDirectoryPath}/Go-Compiler-#{version}/bin:$PATH"})
    end
    
    def prepareInstallation
        super

        exit 1
    end

end
