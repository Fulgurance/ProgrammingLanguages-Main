class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

        if option("Clang")
            moveFile("#{workDirectoryPath(false)}/Clang","#{mainWorkDirectoryPath(false)}/tools/clang")
        end

        if option("Compiler-Rt")
            moveFile("#{workDirectoryPath(false)}/Compiler-Rt","#{mainWorkDirectoryPath(false)}/tools/compiler-rt")
        end
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DLLVM_ENABLE_FFI=ON",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DLLVM_BUILD_LLVM_DYLIB=ON",
                            "-DLLVM_LINK_LLVM_DYLIB=ON",
                            "-DLLVM_ENABLE_RTTI=ON",
                            "-DLLVM_TARGETS_TO_BUILD=\"host;AMDGPU;BPF\"",
                            "-DLLVM_BUILD_TESTS=ON",
                            "-DLLVM_BINUTILS_INCDIR=/usr/include",
                            "-Wno-dev -G Ninja .."],
                            buildDirectoryPath,
                            {"CC" => "gcc","CXX" => "g++"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
