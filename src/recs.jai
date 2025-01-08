#import "String";
#import "Basic";

#assert MAX_COMPONENTS < 64 "max components are 64 rn!";
#assert MAX_ENTITIES < (#run -> u64 { x: s64 = -1; return xx x; }) "max entities 2^64-1, u don need that much!";

#if MAX_COMPONENTS < 8 ComponentsEnum :: u8;
else #if MAX_COMPONENTS < 16 ComponentsEnum :: u16;
else #if MAX_COMPONENTS < 32 ComponentsEnum :: u32;
else ComponentsEnum :: u64;

#if MAX_ENTITIES < (1 << 8) Entity :: u8;
else #if MAX_ENTITIES < (1 << 16) Entity :: u16;
else #if MAX_ENTITIES < (1 << 32) Entity :: u32;
else Entity :: u64;

init_recs :: inline (max_entities := 1000, max_components := 30, assert := true) -> string {
    b: String_Builder;
    init_string_builder(*b);
    defer reset(*b);

    append(*b, sprint("MAX_ENTITIES   :: %;", max_entities));
    append(*b, sprint("MAX_COMPONENTS :: %;", max_components));
    append(*b, sprint("RECS_ASSERT :: %;", assert));

    return builder_to_string(*b);
}

init_components :: inline ($types: ..Type) -> string {
    assert(is_constant(types));
    assert(types.count <= MAX_COMPONENTS);

    #insert #run -> string {
        b: String_Builder;
        init_string_builder(*b);
        defer reset(*b);

        append(*b, sprint("sizes : [%]u32 : .[\n", types.count));
        for types append(*b, sprint("\tsize_of(%),\n", it, it));
        append(*b, "];");

        return builder_to_string(*b);
    };

    b: String_Builder;
    init_string_builder(*b);
    defer reset(*b);

    append(*b, sprint("Component :: enum_flags % {\n", ComponentsEnum));
    for types append(*b, sprint("\t%;\n", it));
    append(*b, "}\n\n");

    for types {
        if sizes[it_index] > 0 append(*b, sprint("_% :: #run -> % { x: %; return x; };", it, it, it));
        else append(*b, sprint("_% :: %;", it, it));
    }

    for types {
        if sizes[it_index] > 0 append(*b, sprint("entity_get :: inline (entity: Entity, $component: %) -> % {\n\t#if RECS_ASSERT assert(entity < MAX_ENTITIES);\n\t#if RECS_ASSERT assert(xx entities[entity] & .%, \"entity doesnt have %\");\n\treturn %_Buff[entity];\n}\n", it, it, it, it, it));
        else append(*b, sprint("entity_get :: inline (entity: Entity, $component : %) -> % {\n\t#if RECS_ASSERT assert(entity < MAX_ENTITIES);\n\t#if RECS_ASSERT assert(xx entities[entity] & .%, \"entity doesnt have %\");\n\tret : %;\n\treturn ret;\n}\n", it, it, it, it, it));
    }

    append(*b, "\n\n");

    for types {
        append(*b, sprint("type_get_component :: inline (_: %) -> Component { return .%; }\n", it, it));
        append(*b, sprint("type_update_buffer :: inline (x: %, i: u32) {\n\t#if RECS_ASSERT assert(i < MAX_ENTITIES);\n\t%_Buff[i] = x;\n}\n", it, it));
    }

    for types if sizes[it_index] > 0 append(*b, sprint("%_Buff : [%]% = ---;\n", it, MAX_ENTITIES, it));

    return builder_to_string(*b);
}

entities_buffer : [MAX_ENTITIES]Component = ---;
entities : []Component = .{ 0, entities_buffer.data };

create_entity :: inline () -> Entity {
    #if RECS_ASSERT assert(entities.count < MAX_ENTITIES);
    e: Entity = xx entities.count;
    entities.count += 1;
    entities[e] = 0;
    return e;
}

remove_entity :: inline (entity: Entity) {
    #if RECS_ASSERT assert(entity < entities.count);
    entities[entity] = entities[entities.count - 1];
    entities.count -= 1;
}

entity_add :: inline (entity: Entity, component: $T) {
    #if RECS_ASSERT assert(entity < entities.count);
    #assert size_of(T) > 0;
    entities[entity] |= type_get_component(component);
    type_update_buffer(component, entity);
}

entity_add :: inline (entity: Entity, component: Component) {
    #if RECS_ASSERT assert(entity < entities.count);
    entities[entity] |= component;
}

entity_update :: inline (entity: Entity, component: $T) {
    #if RECS_ASSERT assert(entity < entities.count);
    #if RECS_ASSERT assert(!!(entities[entity] & type_get_component(component)));
    type_update_buffer(component, entity);
}

entity_remove :: inline (entity: Entity, component: Component) {
    #if RECS_ASSERT assert(entity < entities.count);
    #if RECS_ASSERT assert(!(entities[entity] & component));
    entities[entity] &= ~component;
}

entity_remove :: inline (entity: Entity, component: $T) {
    #if RECS_ASSERT assert(entity < entities.count);
    entities[entity] &= ~type_get_component(component);
}

entity_have :: inline (entity: Entity, component: Component) -> bool {
    #if RECS_ASSERT assert(entity < entities.count);
    return !!(entities[entity] & component);
}

entity_have :: inline (entity: Entity, component: $T) -> bool {
    #if RECS_ASSERT assert(entity < entities.count);
    return !!(entities[entity] & type_get_component(component));
}

entity_have_all :: inline (entity: Entity, components: ..Component) -> bool {
    #if RECS_ASSERT assert(entity < entities.count);
    comps : Component = 0;
    for components comps |= it;
    return (entities[entity] & comps) == comps;
}

entity_have_any :: inline (entity: Entity, components: ..Component) -> bool {
    #if RECS_ASSERT assert(entity < entities.count);
    comps : Component = 0;
    for components comps |= it;
    return !!(entities[entity] & comps);
}

entity_get :: inline (entity: Entity) -> Component {
    #if RECS_ASSERT assert(entities.count < MAX_ENTITIES);
    return entities[entity];
}

run_system :: inline (q: Component, fn: (Entity)) {
    for entities if (it & q) == q fn(xx it_index);
}

run_system :: inline (fn: (Entity)) {
    e: Entity = 0;
    while e < entities.count {
        fn(e);
        e += 1;
    }
}

run_system_once :: inline (q: Component, fn: (Entity)) {
    for entities if (it & q) == q {
        fn(xx it_index);
        break;
    }
}

run_system :: inline (e: Entity, fn: (Entity)) { fn(e); }

run_system :: inline (e: []Entity, fn: (Entity)) { for e fn(it); }
