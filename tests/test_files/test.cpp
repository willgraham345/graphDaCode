class Animal {
public:
    virtual void makeSound() = 0;
};

class Dog : public Animal {
public:
    void makeSound() override {
        // bark
    }
};

class Cat : public Animal {
public:
    void makeSound() override {
        // meow
    }
};

void make_animal_sound(Animal* animal) {
    animal->makeSound();
}

int main() {
    Dog dog;
    Cat cat;
    make_animal_sound(&dog);
    make_animal_sound(&cat);
    return 0;
}
