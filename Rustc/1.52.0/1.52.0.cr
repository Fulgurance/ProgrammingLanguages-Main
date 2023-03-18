class Target < ISM::Software
    
    def extract
        super

        moveFile("#{workDirectoryPath(false)}/crystal-1.7.2","#{workDirectoryPath(false)}/1.7.2")
    end
    
    def build
        super

        makeSource( [Ism.settings.makeOptions],
                    buildDirectoryPath,
                    {"PATH" => "$PATH:#{workDirectoryPath}/crystal-1.7.2-1/bin"})
    end
    
    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"PREFIX=/usr","DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
