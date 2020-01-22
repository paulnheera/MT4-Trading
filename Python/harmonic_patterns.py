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
#%matplotlib qt4

from Python.harmonic_functions import peak_detect
from Python.harmonic_functions import peak_detect2
from Python.harmonic_functions import is_gartley 
from Python.harmonic_functions import is_butterfly
from Python.harmonic_functions import is_crab
from Python.harmonic_functions import is_bat
from Python.harmonic_functions import is_level

# Import historical data

data = pd.read_csv("data/USDCAD240.csv")

data.Time = pd.to_datetime(data.Time,format = "%Y/%m/%d %H:%M")

data = data.set_index(data.Time)

data = data[['Close']]

price = data.Close

err_allowed = 10/100

# Find peaks:
for i in range(100,len(price)):
    
    # Detect patterns:
    current_idx,current_pat,start,end = peak_detect2(price.values[:i],n=4,order=15)
    
    XA = current_pat[1] - current_pat[0]
    AB = current_pat[2] - current_pat[1]
    BC = current_pat[3] - current_pat[2]
    #CD = current_pat[4] - current_pat[3]
    
    moves = [XA,AB,BC]
    moves = [AB,BC]
     
    res = is_level(moves,err_allowed=5/100)
    
    if res == 1:
        
        plt.plot(np.arange(start,i+15),price.values[start:i+15])
        plt.plot(current_idx,current_pat,c="r")
        plt.show()

        
   