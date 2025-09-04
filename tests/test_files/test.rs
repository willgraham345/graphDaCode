trait Animal {
    fn make_sound(&self);
}

struct Dog;

impl Animal for Dog {
    fn make_sound(&self) {
        // bark
    }
}

struct Cat;

impl Animal for Cat {
    fn make_sound(&self) {
        // meow
    }
}

fn make_animal_sound(animal: &dyn Animal) {
    animal.make_sound();
}

fn main() {
    let dog = Dog;
    let cat = Cat;
    make_animal_sound(&dog);
    make_animal_sound(&cat);
}
