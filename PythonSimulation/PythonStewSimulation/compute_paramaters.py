import numpy as np
import matplotlib.pyplot as plt
import control
from numpy import sin, cos

# The main goal of this file is to output a parameter object P that has all the fields we need to do control
# This means that we will do both the physical design of our system and then the control system design on top of our physical system
# The function will return a tuple of all of the parameters we want
def compute_parameters():
    

    # final assignment of control parameters
    kp_x = 0
    kd_x = 0
    ki_x = 0
    kp_y = 0
    kd_y = 0
    ki_y = 0

    return (kp_x, kd_x, ki_x, kp_y, kd_y, ki_y)