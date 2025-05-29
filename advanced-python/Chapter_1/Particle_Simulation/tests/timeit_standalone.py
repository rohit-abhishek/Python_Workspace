import timeit

import os 
import sys 
from pathlib import Path

# get the path of src library and import the module 
file = Path(__file__).resolve()
parent, root = file.parent, file.parents[1]
sys.path.append(str(os.path.join(root, 'src')))

# import Particle and ParticleSimulator class (suppress import warning)
from particle import Particle, ParticleSimulator, benchmark # type: ignore

def timing():
    """ Using timeit function for capturing elapsed time for running """

    result = timeit.timeit(
        "benchmark()", setup="from __main__ import benchmark", number=5
    )

    # Result is the time it takes to run the whole loop
    print(f"Result in running the whole loop: {result}")

    result = timeit.repeat(
        "benchmark()", setup="from __main__ import benchmark", number=5, repeat=3
    )
    # Result is a list of times
    print(f"Result in running the whole loop 3 times: {result}")   

if __name__ == "__main__":
    timing()