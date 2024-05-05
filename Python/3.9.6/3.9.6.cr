class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--enable-shared",
                                "--without-ensurepip"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--enable-shared",
                                "--with-system-expat",
                                "--with-system-ffi",
                                "--with-ensurepip=yes",
                                "--enable-optimizations"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if !option("Pass1")
            makeLink("python3","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/python",:symbolicLink)
        end
    end

end
