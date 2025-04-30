class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr  \
                                        --enable-shared \
                                        --without-ensurepip",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                          \
                                        --enable-shared                         \
                                        --with-system-expat                     \
                                        --enable-optimizations",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if !option("Pass1") && isGreatestVersion
            makeLink(   target: "python#{majorVersion}",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/python",
                        type:   :symbolicLink)

            makeLink(   target: "pip#{majorVersion}",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/pip",
                        type:   :symbolicLink)
        end

        if isGreatestVersion
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d")

            pythonData = <<-CODE
            pathappend /usr/lib/python#{majorVersion}.#{minorVersion}/site-packages PYTHONPATH
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
        end
    end

end
