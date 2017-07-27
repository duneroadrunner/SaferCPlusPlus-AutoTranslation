Jul 2017

This subdirectory contains versions of [LodePNG](https://github.com/lvandeve/lodepng), an open source png encoder/decoder, before and after (partial) conversion from C to [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus). The conversion was done using the "safercpp-arr" tool that's part of the [mutator](https://github.com/bloodstalker/mutator) code analysis project. This conversion assistance tool is still in early development, and at the moment only converts native arrays and pointers used as array iterators to their SaferCPlusPlus counterparts.

Note that this tool uses the "clang libTooling" library and has only been tested on linux (as far as I know).

So here we'll explain the steps used to do the conversion. The first step is to verify that we can build and run the project to be converted. (On our development environment, compiling LodePNG required the following compiler options: -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include' -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include-fixed'.)

Next, we make a copy of the project in a new directory. Although the LodePNG project contains a number of source files, only four are used for the core functionality - lodepng.h, lodepng.cpp, lodepng_util.h and lodepng_util.cpp, so we (chose to) only address those files. 

The format of the conversion command is 

    {mutator_executable_directory}/safercpp-arr {source files to be converted} -- {compiler options}

So, from the source directory of the new copy of the project, we instigate the conversion with a command (in our case) like 

    {mutator_executable_directory}/safercpp-arr lodepng.cpp lodepng_util.cpp -- -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include' -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include-fixed'

This command should result in five new files being written into the project (copy) directory, namely, lodepng.cpp.converted_1, lodepng.h.converted_1, lodepng.h.converted_2, lodepng_util.cpp.converted_2 and lodepng_util.h.converted_2.

Notice that there are two converted versions of lodepng.h. The reason for this is that, due to a limitation of the "clang libTooling" library we use, the tool can only analyze one "translation unit" (i.e source file) at a time. And since lodepng.h is included by both lodepng.cpp and lodepng_util.cpp, the conversion tool produces one converted version of lodepng.h from analyzing lodepng.cpp, and another version from analyzing lodepng_util.cpp. So lodepng.h.converted_1 comes from analysis of the first source file (lodepng.cpp), and lodepng.h.converted_2 comes from analysis of the second source file (lodepng_util.cpp). A lot of the changes will be common to both converted versions, but some won't be. So at this point, you're going to want to merge the changes from both versions. For example, you can use a merge tool like meld:

    meld lodepng.h.converted_1 lodepng.h lodepng.h.converted_2

When, during the merge, you encounter a conflict between a change to MSE_LH_DYNAMIC_ARRAY_ITERATOR_TYPE() and a change to MSE_LH_ARRAY_ITERATOR_TYPE(), choose the former. 

After executing the merge, replace the rest of the source files with their converted versions, and we're done. Almost. We just need to download the [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus) library and make sure it's in the include path. That should be it. This copy of the project should compile and run. And, in theory, be safer as all the arrays have been replaced with memory-safe substitutes.


Note that, aside from the merge, no hand editing of the code was required here. While that was the case for this project, that will not necessarily be the case for other projects. The tool is not yet complete, and may not be able to catch every place where the code needs to be modified.
