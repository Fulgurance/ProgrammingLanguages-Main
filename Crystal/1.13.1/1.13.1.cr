class Target < ISM::Software
    
    def build
        super

        makeSource( path:           buildDirectoryPath,
                    environment:    {"PATH" => "#{ENV["PATH"]}:#{workDirectoryPath}/Crystal-Compiler-1.13.1/bin"})
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "PREFIX=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
