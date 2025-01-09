# RECS: ECS library in Jai

An easy-to-use Entity Component System (ECS) library written in Jai. This library provides a simple and efficient foundation for managing entities, components, and systems in your game

## Features

- **Entity Management:** Create, delete, and manage entities effortlessly.

- **Component Management:** Add, remove, and retrieve components attached to entities.

- **Systems:** A robust system for defining and executing game logic across entities and components.

- **Iterators:** Seamless iteration over entities and components for efficient processing.

## Upcoming Features

- *Efficient Storage:* Optimized data storage for components to ensure fast access and minimal overhead.

## Usage

### Install

```sh
git clone https://github.com/666rayen999/recs
```
Edit the `src/main.jai`

### Import the library + Init

```odin
// set max entities and max components
@init_recs(max_entities = 4, max_components = 10);
```

### Add Components

```odin
Player   :: @comp void; // zero sized component
UI       :: @comp(); // zero sized component
Position :: @comp struct {
    x: float;
    y: float;
};
Health   :: @comp float;

@init_components(Player, Position, Health);
```
```odin
Position :: @comp Vector2;
Position :: @component Vector2;
```

### Add Entities

```odin
e := create_entity();
entity_add(e, .Player); // zero sized
entity_add(e, Position.{0, 0});
```

### Add Systems

```odin
run_system(.Position, (ent: Entity) {
    print("%\n", ent);
});

func :: (ent: Entity) {
    pos := entity_get(e, _Position);
    print("%: %\n", e, pos);
}

run_system(.Position, func); // all entities that have Position

run_system_once(.Position, func); // first entity that have Position

run_system(e, func); // run func on entity e

run_system(.[e1, e2, e3], func); // run func on entities

run_system(func);  // run func on all entities
```

### Iterators

```odin
for iter_entities(.Position | .Velocity) {
    pos := entity_get(it, _Position);
    vel := entity_get(it, _Velocity);
    print("% + %\n", pos, vel);
}
```

### Example

```odin
#import "Math";

@init_recs();

Print    :: @comp void;
Position :: @comp Vector2;
Velocity :: @comp Vector2;

@init_components(Print, Position, Velocity);

printing_system :: inline (e: Entity) {
    pos := entity_get(e, _Position);
    print("%\n", pos);
}

movement_system :: inline (e: Entity) {
    pos := entity_get(e, _Position);
    vel := entity_get(e, _Velocity);
    pos.x += vel.x;
    pos.y += vel.y;
    entity_update(e, pos);
}

main :: () {
    e := create_entity();

    entity_add(e, Position.{});
    entity_add(e, Velocity.{1, 0});
    entity_add(e, .Print);

    e = create_entity();

    entity_add(e, Position.{});
    entity_add(e, Velocity.{0, 1});
    entity_add(e, .Print);

    e = create_entity();

    entity_add(e, Position.{});
    entity_add(e, .Print);

    for 0..3 {
        print("frame %:\n", it);
        run_system(.Position | .Velocity, movement_system);
        run_system(.Position | .Print, printing_system);
        print("\n");
    }

    for iter_entities(.Position) {
        entity_update(it, Position.{});
    }
}
```

## Contributing

Contributions are welcome! If you have ideas or bug fixes, feel free to submit a pull request or open an issue on GitHub.

## License

This library is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
