#run {
    set_build_options_dc(.{do_output = false});

    w := compiler_create_workspace("Target workspace");
    options := get_build_options(w);

    args := options.compile_time_command_line;
    release := array_find(args, "release");

    options.output_executable_name = "recs";

    if release set_optimization(*options, .VERY_OPTIMIZED, false);
    set_build_options(options, w);

    compiler_begin_intercept(w);
    if release add_build_string(tprint("DEBUG :: false;\n"), w);
    else add_build_string(tprint("DEBUG :: true;\n"), w);
    add_build_file("src/main.jai", w);
    compiler_end_intercept(w);
}

#import "Compiler";
#import "Basic";
