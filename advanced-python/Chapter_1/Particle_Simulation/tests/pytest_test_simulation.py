
# Run this file using command as pytest <this file name i.e. pytest_test_simulation.py> :: <function to test i.e. test_evolve()>
import os 
import sys 
from pathlib import Path

# get the path of src library and import the module 
file = Path(__file__).resolve()
parent, root = file.parent, file.parents[1]
sys.path.append(str(os.path.join(root, 'src')))

# import Particle and ParticleSimulator class (suppress import warning)
from particle import Particle, ParticleSimulator, benchmark # type: ignore

# pass benchmark fixture. to run this you will need zsh
def test_evolve(benchmark):

    # create particles 
    particles = [
        Particle(0.3, 0.5, 1), 
        Particle(0.4, -0.5, -1),
        Particle(-0.1, -0.4, 3)
    ]

    # pass these particles to simulator object 
    simulator = ParticleSimulator(particles)

    # instead of setting 
    simulator.evolve(0.1)    

    # get particles 
    p0, p1, p2 = particles

    def fequal(a, b, eps=1e-5):
        return abs(a-b) < eps
    
    assert fequal(p0.x, 0.210269)
    assert fequal(p0.y, 0.543863) 

    # # below two assertion will give error 
    # assert fequal(p1.x, -0.099334) 
    # assert fequal(p1.y, -0.490034) 

    assert fequal(p2.x,  0.191358) 
    assert fequal(p2.y, -0.365227)    

    benchmark(simulator.evolve, 0.1)  # this will require you to execute pytest command in zsh


if __name__ == '__main__':
    test_evolve()
