from abc import ABC, abstractmethod

class Animal(ABC):
    @abstractmethod
    def make_sound(self):
        pass

class Dog(Animal):
    def make_sound(self):
        # bark
        pass

class Cat(Animal):
    def make_sound(self):
        # meow
        pass

def make_animal_sound(animal: Animal):
    animal.make_sound()

if __name__ == "__main__":
    dog = Dog()
    cat = Cat()
    make_animal_sound(dog)
    make_animal_sound(cat)
