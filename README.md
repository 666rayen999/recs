# RECS: ECS library in Jai

An easy-to-use Entity Component System (ECS) library written in Jai. This library provides a simple and efficient foundation for managing entities, components, and systems in your game

## Features

- *Entity Management:* Create, delete, and manage entities effortlessly.

- *Component Management:* Add, remove, and retrieve components attached to entities.

## Upcoming Features

- *Efficient Storage:* Optimized data storage for components to ensure fast access and minimal overhead.

- *Iterators:* Seamless iteration over entities and components for efficient processing.

- *Systems:* A robust system for defining and executing game logic across entities and components.

## Usage

### Install

```sh
git clone https://github.com/666rayen999/recs
```
Edit the `src/main.jai`

### Import the library + Init

```odin
#recs;
#init_recs(max_entities = 4, max_components = 10); // set max entities and max components
```
OR
```odin
#recs;
#insert #run init_recs(max_entities = 4, max_components = 10); // set max entities and max components
```

### Add Components

```odin
#comp Player; // zero sized component
#comp Position : Vector2;
#comp Health   : float;

#init_components(Player, Position, Health);
```
OR
```odin
Player   :: #type,distinct void; // zero sized component
Position :: #type,distinct Vector2;
Health   :: #type,distinct float;

#insert #run init_components(Player, Position, Health);
```

### Add Entities

```odin
e := create_entity();
entity_add(e, .Player); // zero sized
entity_add(e, Position.{0, 0});
```

### Example

```odin
#recs;
#import "Math";

#init_recs();

#comp Player;
#comp Position : Vector2;
#comp Velocity : Vector2;
#comp Health   : float32;

#init_components(Player, Position, Velocity, Health);

main :: () {
    e := create_entity();

    entity_add(e, .Player);
    entity_add(e, Position.{0, 0});
    assert(entity_have(e, .Position));

    entity_add(e, Velocity.{1, 2});
    assert(entity_have_all(e, .Position, .Velocity));

    entity_remove(e, .Velocity);
    assert(entity_have_any(e, .Position, .Health));
}
```

## Contributing

Contributions are welcome! If you have ideas or bug fixes, feel free to submit a pull request or open an issue on GitHub.

## License

This library is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.