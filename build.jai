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

    main, ok := read_entire_file("src/main.jai");
    assert(ok, "main.jai not found!");
    recs, ok2 := read_entire_file("src/recs.jai");
    assert(ok2, "recs.jai not found!");

    main = replace(main, "#recs;", recs);
    main = replace(main, "#init_recs(", "#insert #run init_recs(");
    main = replace(main, "#init_components(", "#insert #run init_components(");
    found, left, right := split_from_left(main, "#comp ");

    m: String_Builder;
    init_string_builder(*m);
    defer reset(*m);

    append(*m, left);

    while found {
        a := find_index_from_left(right, #char ":");
        b := find_index_from_left(right, #char ";");

        assert(a != -1 && b != -1);

        if a < b {
            ok, left, right = split_from_left(right, "::");
            assert(ok);
            append(*m, left);
            append(*m, ":: #type,distinct ");
        } else {
            ok, left, right = split_from_left(right, ";");
            assert(ok);
            append(*m, left);
            append(*m, ":: #type,distinct void;");
        }


        found, left, right = split_from_left(right, "#comp ");
        append(*m, left);
    }

    add_build_string(builder_to_string(*m), w);
    compiler_end_intercept(w);
}

#import "Compiler";
#import "Basic";
#import "File";
#import "String";
