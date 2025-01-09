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
    entity_add(e, Position.{0, 0});

    e1 := create_entity();
    entity_add(e1, Velocity.{1, 2});

    e2 := create_entity();
    entity_add(e2, Position.{1, 2});

    run_system(.Position, (ent: Entity) {
        print("%\n", entity_get(ent, _Position));
    });

    for iter_entities(.Position) {
        print("%\n", entity_get(it, _Position));
    }
}

