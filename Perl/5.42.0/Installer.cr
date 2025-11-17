class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            runFile(file:       "Configure",
                    arguments:  "-des                                                               \
                                -Dprefix=/usr                                                       \
                                -Dvendorprefix=/usr                                                 \
                                -Duseshrplib                                                        \
                                -Dprivlib=/usr/lib/perl#{majorVersion}/#{version}/core_perl         \
                                -Darchlib=/usr/lib/perl#{majorVersion}/#{version}/core_perl         \
                                -Dsitelib=/usr/lib/perl#{majorVersion}/#{version}/site_perl         \
                                -Dsitearch=/usr/lib/perl#{majorVersion}/#{version}/site_perl        \
                                -Dvendorlib=/usr/lib/perl#{majorVersion}/#{version}/vendor_perl     \
                                -Dvendorarch=/usr/lib/perl#{majorVersion}/#{version}/vendor_perl    \
                                -Dman1dir=/usr/share/man/man1                                       \
                                -Dman3dir=/usr/share/man/man3                                       \
                                -Duseithreads",
                    path:       buildDirectoryPath)
        else
            runFile(file:           "Configure",
                    arguments:      "-des                                                               \
                                    -Dprefix=/usr                                                       \
                                    -Dvendorprefix=/usr                                                 \
                                    -Dprivlib=/usr/lib/perl#{majorVersion}/#{version}/core_perl         \
                                    -Darchlib=/usr/lib/perl#{majorVersion}/#{version}/core_perl         \
                                    -Dsitelib=/usr/lib/perl#{majorVersion}/#{version}/site_perl         \
                                    -Dsitearch=/usr/lib/perl#{majorVersion}/#{version}/site_perl        \
                                    -Dvendorlib=/usr/lib/perl#{majorVersion}/#{version}/vendor_perl     \
                                    -Dvendorarch=/usr/lib/perl#{majorVersion}/#{version}/vendor_perl    \
                                    -Dman1dir=/usr/share/man/man1                                       \
                                    -Dman3dir=/usr/share/man/man3                                       \
                                    -Dpager=\"/usr/bin/less -isR\"                                      \
                                    -Duseshrplib                                                        \
                                    -Duseithreads                                                       \
                                    -Dusethreads",
                    path:           buildDirectoryPath,
                    environment:    {"BUILD_ZLIB" => "False","BUILD_BZIP2" => "0"})
        end
    end
    
    def build
        super

        if option("Pass1")
            makeSource(path: buildDirectoryPath)
        else
            makeSource( path:           buildDirectoryPath,
                        environment:    {"BUILD_ZLIB" => "False","BUILD_BZIP2" => "0"})
        end
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath)
        else
            makeSource( arguments:      "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:           buildDirectoryPath,
                        environment:    {"BUILD_ZLIB" => "False","BUILD_BZIP2" => "0"})
        end
    end

end
