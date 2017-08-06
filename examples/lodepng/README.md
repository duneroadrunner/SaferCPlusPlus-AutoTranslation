Jul 2017

This subdirectory contains versions of [LodePNG](https://github.com/lvandeve/lodepng), an open source png encoder/decoder, before and after (partial) conversion from C to [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus). The conversion was done using the "safercpp-arr" tool that's part of the [mutator](https://github.com/bloodstalker/mutator) code analysis project. This conversion assistance tool is still in early development, and at the moment only converts native arrays and pointers used as array iterators to their SaferCPlusPlus counterparts.

Note that this tool uses the "clang libTooling" library and has only been tested on linux (as far as I know).

So here we'll explain the steps used to do the conversion. The first step is to verify that we can build and run the project to be converted. (On our development environment, compiling LodePNG required the following compiler options: -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include' -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include-fixed'.)

Next, we make a copy of the project in a new directory. Although the LodePNG project contains a number of source files, only four are used for the core functionality - lodepng.h, lodepng.cpp, lodepng_util.h and lodepng_util.cpp, so we (chose to) only address those files. 

The format of the conversion command is 

    {mutator_executable_directory}/safercpp-arr {source files to be converted} -- {compiler options}

So, from the source directory of the new copy of the project, we instigate the conversion with a command (in our case) like 

    {mutator_executable_directory}/safercpp-arr lodepng.cpp lodepng_util.cpp -- -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include' -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include-fixed'

After some processing, the program will prompt for confirmation before replacing the source files with their converted versions. (The prompt can be suppressed with the "-SuppressPrompts" option.)

After running the conversion tool, some hand-processing may still need to be done. For example, if we try to compile the converted project we may get a compile error at line 711 of the lodepng.h file where we may find the following code:

    <<<<<<< /home/user1/dev/clang_tooling/mutator/targets_for_mutation/lodepng/lodepng-master/src/lodepng.h.converted
    MSE_LH_ARRAY_ITERATOR_TYPE(unsigned char)  lodepng_chunk_next(MSE_LH_ARRAY_ITERATOR_TYPE(unsigned char)  chunk);
    const MSE_LH_ARRAY_ITERATOR_TYPE(const unsigned char)  lodepng_chunk_next_const(MSE_LH_ARRAY_ITERATOR_TYPE(const unsigned char)  chunk);
    =======
    unsigned char* lodepng_chunk_next(unsigned char* chunk);
    const MSE_LH_ARRAY_ITERATOR_TYPE(const unsigned char)  lodepng_chunk_next_const(MSE_LH_ARRAY_ITERATOR_TYPE(const unsigned char)  chunk);
    >>>>>>> /home/user1/dev/clang_tooling/mutator/targets_for_mutation/lodepng/lodepng-master/src/lodepng.h.converted_2

You may recognize the format of this code snippet as the result of a [conflict encountered during a merge](https://linux.die.net/man/1/merge). Indeed that is this case here. So here we're going to need to resolve the conflict as we would with any other merge conflict. In this case, just keep the code from the first part and delete the second part. 

After fixing the merge conflict, we're done. Almost. We just need to download the [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus) library and make sure it's in the include path. That should be it. This copy of the project should compile and run. And, in theory, be safer as all the arrays and array pointers have been replaced with memory-safe substitutes.

