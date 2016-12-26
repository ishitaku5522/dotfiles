from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

# x = np.arange(-3, 3, 0.25)
# y = np.arange(-3, 3, 0.25)
# x = np.arange(0, 10)
# y = np.arange(0, 10)
fig = plt.figure()
ax = Axes3D(fig)
for t in range(100):
    x = t
    y = t
    z = t

    print x
    print y
    #

    # X, Y = np.meshgrid(x, y)
    Z = 0

    # print X
    # print Y

    plt.gca().clear()
    ax.set_xlim3d(-10, 110)
    ax.set_ylim3d(-10, 110)
    ax.set_zlim3d(-10, 110)
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    ax.set_zlabel("z")
    ax.scatter(x, y, z)
    plt.pause(0.01)