Jun 2017

This subdirectory contains versions of [LodePNG](https://github.com/lvandeve/lodepng), an open source png encoder/decoder, before and after (partial) conversion from C to [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus). The conversion was done using the "safercpp-arr" tool that's part of the [mutator](https://github.com/bloodstalker/mutator) code analysis project. This conversion assistance tool is still in early development, and at the moment only converts native arrays and pointers used as array iterators to their SaferCPlusPlus counterparts.

Note that this tool uses the "clang libTooling" library and has only been tested on linux (as far as I know).

So here we'll explain the steps used to do the conversion. The first step is to verify that we can build and run the project to be converted. (On our development environment, compiling LodePNG required the following compiler options: -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include' -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include-fixed'.)

Next, we make a copy of the project in a new directory. Although the LodePNG project contains a number of source files, only four are used for the core functionality - lodepng.h, lodepng.cpp, lodepng_util.h and lodepng_util.cpp, so we (chose to) only address those files. Currently, the tool can only properly handle conversion of one source file at a time. (This is due to a limitiation in the "clang libTooling" library we use. This issue seems to be in the process of being addressed on their end.)

Since in this case there are only a couple of source files, we can specify the conversion of each one individually. The format of the conversion command is 

    {mutator_executable_directory}/safercpp-arr {source file to be converted} -- {compiler options}

So, from the source directory of the new copy of the project, we first convert the lodepng_util.cpp source file with a command (in our case) like 

    {mutator_executable_directory}/safercpp-arr lodepng_util.cpp -- -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include' -I'/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include-fixed'

This command results in three files being modified - lodepng_util.cpp and the header files it includes, lodepng_util.h and lodepng.h. All modified files should have the following #include directive inserted somewhere (near the beginning) of file

    #include "mselegacyhelpers.h"

The console output of the conversion command may contain error messages like "error: unable to make temporary file: /usr/include/stdlib.h-45536ff1". For now, that's expected.

At this point, the modified project is not (necessarily) compilable anymore because the changes made may be inconsistent with the source files that have not yet been converted. But the conversion tool can only operate (properly) on source that compiles (without error). So we can't convert the next source file from this modified version of the project source, we need to convert it from another (clean) copy of the original source.

So after converting the next source file, lodepng.cpp, in the same manner as we did with lodepng_util.cpp, we end up with two modified copies of the project, neither of which is compilable. What we need to do next is merge the modifications made by each conversion.

So we make one more copy of the original project source. For each file that was modified we do a 3-way merge (using meld, or your favorite merge tool), saving the result in this last copy of the project. It turns out that the only file that's modified by both conversions is the lodepng.h file, so the other modified files don't even require a merge.

Since lodepng_util.cpp and lodepng.cpp are the only (non-header) source files of interest to us, we're done. Almost. We just need to download the [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus) library and make sure it's in the include path. That should be it. This copy of the project with the merged modifications should compile and run. And, in theory, be safer as all the arrays have been replaced with memory-safe substitutes.
