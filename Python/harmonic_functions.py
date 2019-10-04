# -*- coding: utf-8 -*-
"""
Created on Thu Oct  3 15:49:43 2019

@author: pnheera
"""

import numpy as np
from scipy.signal import argrelextrema

def peak_detect(price,order=10):
    
    # Find out relative local extrema:
    max_ind = list(argrelextrema(price,np.greater,order=order)[0])
    min_ind = list(argrelextrema(price,np.less,order=order)[0])

    idx = max_ind + min_ind + [len(price)-1]

    idx.sort()

    current_idx = idx[-5:] # Take the last 5 peaks
    
    start = min(current_idx)
    end = max(current_idx)
    
    current_pat = price[current_idx]
    
    return current_idx,current_pat,start,end

def is_gartley(moves,err_allowed):
    
    XA = moves[0]
    AB = moves[1]
    BC = moves[2]
    CD = moves[3]
    
    AB_range = np.array([0.618 - err_allowed,0.618 + err_allowed])*abs(XA)
    BC_range = np.array([0.381 - err_allowed,0.382 + err_allowed])*abs(AB)
    CD_range = np.array([1.27 - err_allowed,1.27 + err_allowed])*abs(BC)
    
    # Bullish Gartely pattern:
    if XA > 0 and AB < 0 and BC > 0 and CD < 0:
        
        if AB_range[0] < abs(AB) < AB_range[1] and BC_range[0] < abs(BC) < BC_range[1] and CD_range[0] < abs(CD) < CD_range[1]:
            return 1
        else:
            return np.NAN
    
    elif XA < 0 and AB > 0 and BC < 0 and CD > 0:   
        
        if AB_range[0] < abs(AB) < AB_range[1] and BC_range[0] < abs(BC) < BC_range[1] and CD_range[0] < abs(CD) < CD_range[1]:
            return -1
        else:
            return np.NAN

    else:
        return np.NAN
    
def is_butterfly(moves,err_allowed):
    
    XA = moves[0]
    AB = moves[1]
    BC = moves[2]
    CD = moves[3]
    
    AB_range = np.array([0.786 - err_allowed,0.786 + err_allowed])*abs(XA)
    BC_range = np.array([0.382 - err_allowed,0.382 + err_allowed])*abs(AB)
    CD_range = np.array([1.618 - err_allowed,1.618 + err_allowed])*abs(BC)
    
    # Bullish Gartely pattern:
    if XA > 0 and AB < 0 and BC > 0 and CD < 0:
        
        if AB_range[0] < abs(AB) < AB_range[1] and BC_range[0] < abs(BC) < BC_range[1] and CD_range[0] < abs(CD) < CD_range[1]:
            return 1
        else:
            return np.NAN
    
    elif XA < 0 and AB > 0 and BC < 0 and CD > 0:   
        
        if AB_range[0] < abs(AB) < AB_range[1] and BC_range[0] < abs(BC) < BC_range[1] and CD_range[0] < abs(CD) < CD_range[1]:
            return -1
        else:
            return np.NAN

    else:
        return np.NAN
    