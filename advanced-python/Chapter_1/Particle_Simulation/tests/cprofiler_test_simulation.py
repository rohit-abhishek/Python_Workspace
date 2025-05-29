
# Run this file using command as pytest <this file name i.e. pytest_test_simulation.py> :: <function to test i.e. test_evolve()>
import os 
import sys 
from pathlib import Path

# get the path of src library and import the module 
file = Path(__file__).resolve()
parent, root = file.parent, file.parents[1]
sys.path.append(str(os.path.join(root, 'src')))

# import Particle and ParticleSimulator class (suppress import warning)
from particle import benchmark # type: ignore

import cProfile

# Method 1: calling cProfile using run command
# cProfile.run("benchmark()", sort='tottime')

# Method 2: calling cProfile using Profile object
pr = cProfile.Profile()
pr.enable()
benchmark()
pr.disable()
pr.print_stats(sort="tottime")