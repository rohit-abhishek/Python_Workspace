from Chapter_1.Particle_Simulation.src.particle import Particle, ParticleSimulator
from random import uniform

# added by RA 
from line_profiler import profile
from memory_profiler import profile as mprofile

@profile
def close(particles, eps=1e-5):
    """ check if two particles are close to each other by less than 1e-5 """
    p0, p1 = particles

    x_dist = abs(p0.x - p1.x)
    y_dist = abs(p0.y - p1.y)

    return x_dist < eps and y_dist < eps

@profile
# @mprofile
def benchmark():
    particles = [
        Particle(uniform(-1.0, 1.0), uniform(-1.0, 1.0), uniform(-1.0, 1.0))
        for i in range(2)
    ]

    simulator = ParticleSimulator(particles)
    simulator.evolve(0.1)

    print(close(particles))


if __name__ == '__main__':
    benchmark()
