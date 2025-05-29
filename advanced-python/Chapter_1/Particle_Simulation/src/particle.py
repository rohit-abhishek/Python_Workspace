from line_profiler import profile
from matplotlib import pyplot as plt 
from matplotlib import animation
from random import uniform
import numpy as np

from memory_profiler import profile as mprofile

class Particle :
    """ Create particle """

    # below code is added after running memory profiler where 100000 particle objects were created
    __slots__ = ('x', 'y', 'ang_vel')

    def __init__(self, x, y, ang_vel):
        self.x = x 
        self.y = y
        self.ang_vel = ang_vel

class ParticleSimulator: 
    """ Create particle simulator """
    def __init__(self, particles):
        self.particles = particles

    # add decorator profile for line by line profiling using kernprof.py. This will be injected in the global namespace. remove this when running on standalone basis.
    # @profile
    def evolve(self, dt):
        
        # set timestep to 0.00001 
        timestep = 0.00001

        # numbner of steps in the simulation will be integer value of small elapsed time divided by timestep 
        nsteps = int(dt / timestep)

        # iterate for all steps 
        for i in range(nsteps):
            
            # for each particle iterate
            for p in self.particles:

                # get the direction 
                norm = (p.x ** 2 + p.y ** 2) ** 0.5 
                v_x = (-p.y)/norm 
                v_y = p.x/norm 

                # get the displacement 
                d_x = timestep * p.ang_vel * v_x
                d_y = timestep * p.ang_vel * v_y

                # increment the values for particles 
                p.x += d_x
                p.y += d_y

    @profile
    def evolve_faster(self, dt): 
        """ This is created after running line by line profiling of evolve method and then optimizing the code """

        timestep = 0.00001
        nsteps = int(dt / timestep)

        # change the loop order 
        for p in self.particles:

            # get the angular distance covered 
            t_x_ang = timestep * p.ang_vel

            # now iterate through the steps 
            for i in range(nsteps):
                norm = (p.x ** 2 + p.y ** 2) ** 0.5
                p.x, p.y = p.x - t_x_ang*p.y/norm, p.y + t_x_ang * p.x/norm

    
    # code from chapter 3 using numpy 
    def evolve_numpy(self, dt):
        """ This method is created in chapter 3 of the book using numpy to perform the operations using numpy package"""
        
        timestep = 0.00001
        nsteps = int(dt / timestep)

        # store all coordinates and angular velocity for particles 
        ri = np.array([[p.x, p.y] for p in self.particles])
        ang_vel = np.array([p.ang_vel for p in self.particles])

        # loop this 
        for i in range(nsteps): 

            # calculate the norm of vector 
            norm_i = np.sqrt((ri ** 2).sum(axis=1))

            # calculate the velocity which is perpendicular to vector (x,y) thus calculate (-y,x)
            vi = ri[:, [1,0]]
            vi[:, 0] *= -1
            vi /= norm_i[:, np.newaxis]

            # to find the displacement we need to have vi, angular velocity and timestep 
            di = timestep * ang_vel[:,np.newaxis] * vi
            ri += di

            for i, p in enumerate(self.particles):
                p.x, p.y = ri[i]


def visualize(simulator):

    # create the list of particle simulator at different points 
    # X = [p.x for p in simulator.particles]
    # Y = [p.y for p in simulator.particles]

    X = [] 
    Y = []

    # create matplot figure
    fig = plt.figure()

    # create a subplot
    ax = plt.subplot(111, aspect='equal')
    (line,) = ax.plot(X, Y, 'ro')

    # pose X and Y axis limit
    plt.xlim(-1, 1)
    plt.ylim(-1, 1)

    # execute when animation starts
    def init():
        line.set_data([], [])
        return (line,)
    
    def animate(i):
        # simulator.evolve(0.01)
        # simulator.evolve_faster(0.01)
        simulator.evolve_numpy(0.01)
        
        X = [p.x for p in simulator.particles]
        Y = [p.y for p in simulator.particles]

        line.set_data(X, Y)

        return (line,)

    # call animation for every 10ms 
    anim = animation.FuncAnimation(fig, animate, init_func=init, blit=True, interval=10)
    plt.show()

def test_visualize(): 

    # create particles 
    particles = [
        Particle(0.3, 0.5, 1), 
        Particle(0.4, -0.5, -1),
        Particle(-0.1, -0.4, 1.5)
    ]
    
    # pass these particles to simulator object 
    simulator = ParticleSimulator(particles)

    # visualize the simulation 
    visualize(simulator=simulator)



def benchmark(nparts=1000, method='python'): 
    """ Assertion will not provide the complete picture what is taking too long 
    this method will create thousands of particle objects and feed to the system 
    """

    particles = [
        Particle(uniform(-1.0, 1.0), uniform(-1.0, 1.0), uniform(-1.0, 1.0))
        for i in range(nparts) 
    ]

    simulator = ParticleSimulator(particles)
    # simulator.evolve(0.1)
    if method == 'python':
        simulator.evolve_faster(0.1)
    else:
        simulator.evolve_numpy(0.1)


# add decorator to run this with mprof for memory profiling
@mprofile
def benchmark_memory(): 
    """ This piece of code is added for benchmarking memory usage """
    particles = [Particle(uniform(-1.0,1.0), uniform(-1.0,1.0), uniform(-1.0, 1.0)) for i in range(100000)]
    simulator = ParticleSimulator(particles)
    # simulator.evolve_faster(0.001)
    simulator.evolve_numpy(0.001)

if __name__ == '__main__':
    test_visualize()
    # test_evolve()
    # benchmark()
    # benchmark_memory()
    # timing()