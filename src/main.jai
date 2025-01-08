#load "recs.jai";
#import "Math";

#insert #run init_recs(max_entities = 4, max_components = 10);

Player   :: #type,distinct void;
Position :: #type,distinct Vector2;
Velocity :: #type,distinct Vector2;
Health   :: #type,distinct float32;

#insert #run init_components(Player, Position, Velocity, Health);

main :: () {
    e := create_entity();

    entity_add(e, Position.{0, 0}); // add component to entity
    assert(entity_have(e, .Position)); // check if it have component

    entity_add(e, Velocity.{1, 2});
    assert(entity_have_all(e, .Position, .Velocity)); // check if it have all components

    entity_remove(e, .Velocity);
    assert(entity_have_any(e, .Position, .Health)); // check if it have any component
}

