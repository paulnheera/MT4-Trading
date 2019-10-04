# -*- coding: utf-8 -*-
"""
Created on Sat Sep 28 12:04:29 2019

@author: pnheera
"""

import numpy as np
import pandas as pd
from scipy.signal import argrelextrema
import matplotlib.pyplot as plt
%matplotlib inline

from Python.harmonic_functions import peak_detect
from Python.harmonic_functions import is_gartley 
from Python.harmonic_functions import is_butterfly

# Import historical data

data = pd.read_csv("data/EURUSD60.csv")

data.Time = pd.to_datetime(data.Time,format = "%Y/%m/%d %H:%M")

data = data.set_index(data.Time)

data = data[['Close']]

price = data.Close

err_allowed = 10/100

# Find peaks:
for i in range(100,len(price)):
    
    # Detect patterns:
    current_idx,current_pat,start,end = peak_detect(price.values[:i])
    
    XA = current_pat[1] - current_pat[0]
    AB = current_pat[2] - current_pat[1]
    BC = current_pat[3] - current_pat[2]
    CD = current_pat[4] - current_pat[3]
    
    moves = [XA,AB,BC,CD]
     
    res = is_butterfly(moves,err_allowed=10/100)
    
    if res == -1:
        
        plt.plot(np.arange(start,i+15),price.values[start:i+15])
        plt.plot(current_idx,current_pat,c="r")
        plt.show()
   