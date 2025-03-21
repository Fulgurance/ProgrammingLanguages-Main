class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

        if option("Clang")
            moveFile(   "#{workDirectoryPath}/Clang",
                        "#{mainWorkDirectoryPath}/tools/clang")
        end

        if option("Compiler-Rt")
            moveFile(   "#{workDirectoryPath}/Compiler-Rt",
                        "#{mainWorkDirectoryPath}/projects/compiler-rt")
        end
    end
    
    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr/lib/llvm/16        \
                                        -DLLVM_HOST_TRIPLE=#{Ism.settings.systemTarget} \
                                        -DLLVM_ENABLE_FFI=ON                            \
                                        -DCMAKE_BUILD_TYPE=Release                      \
                                        -DLLVM_BUILD_LLVM_DYLIB=ON                      \
                                        -DLLVM_LINK_LLVM_DYLIB=ON                       \
                                        -DLLVM_ENABLE_RTTI=ON                           \
                                        -DLLVM_TARGETS_TO_BUILD=\"host;BPF\"            \
                                        -DLLVM_BINUTILS_INCDIR=/usr/include             \
                                        -DLLVM_INCLUDE_BENCHMARKS=OFF                   \
                                        -DCLANG_DEFAULT_PIE_ON_LINUX=ON                 \
                                        -Wno-dev -G Ninja ..",
                        path:           buildDirectoryPath,
                        environment:    {"CC" => "gcc","CXX" => "g++"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        copyFile(   "#{buildDirectoryPath}/bin/FileCheck",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/FileCheck")

        if isGreatestVersion
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/ld.so.conf.d")

            ldsoData = <<-CODE
            /usr/lib/llvm/#{majorVersion}/lib
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}etc/ld.so.conf.d/llvm.conf",ldsoData)

            directoryContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/llvm/18/bin", matchHidden: true).each do |filePath|

                fileName = filePath.lchop(filePath[0..filePath.rindex("/")])

                makeLink(   target: "/usr/lib/llvm/18/bin/#{fileName}",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/#{fileName}",
                            type:   :symbolicLinkByOverwrite)

            end
        end

    end

end
