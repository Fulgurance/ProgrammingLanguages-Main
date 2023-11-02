class Target < ISM::Software
    
    def build
        super

        makeSource( path: buildDirectoryPath,
                    environment: {"PATH" => "$PATH:#{workDirectoryPath}/Crystal-Compiler-1.7.2/bin"})
    end
    
    def prepareInstallation
        super

        makeSource(["PREFIX=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
