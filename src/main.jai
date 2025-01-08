#import "Math";

init_recs(); // set max entities and max components

// init comps
Player   :: #comp void;
Position :: #comp Vector2;
Velocity :: #comp Vector2;
Health   :: #comp float32;

init_components(Player, Position, Velocity, Health);

// start da big
main :: () {
    e := create_entity();

    entity_add(e, .Player);
    entity_add(e, Position.{0, 0}); // add component to entity
    assert(entity_have(e, .Position)); // check if it have component

    entity_add(e, Velocity.{1, 2});
    assert(entity_have_all(e, .Position, .Velocity)); // check if it have all components

    entity_remove(e, .Velocity);
    assert(entity_have_any(e, .Position, .Health)); // check if it have any component
}

