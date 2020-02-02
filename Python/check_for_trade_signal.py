# -*- coding: utf-8 -*-
"""
Created on Tue Oct 29 15:24:11 2019

@author: pnheera
"""
# Import Libraries ------------------------------------------------------------
import numpy as np
import pandas as pd
from scipy.signal import argrelextrema
import matplotlib.pyplot as plt
#%matplotlib inline
import os
import smtplib

# Set Working Directory
path = "C:/Users/paul/repos/MT4-Trading"
os.chdir(path)

# Import User Defined Libraries
#from Python.harmonic_functions import peak_detect2
#from Python.harmonic_functions import is_three_steps
#from Python.harmonic_functions import is_level
exec(open('Python/harmonic_functions.py').read())

def scan_retracements(price):
    
    for i in range(100,len(price)):
        
        current_idx,current_pat,start,end = peak_detect2(price.values[:i],n=3)
        
        XA = current_pat[1] - current_pat[0]
        AB = current_pat[2] - current_pat[1]
        
        moves = [XA,AB]
        
        res = is_level(moves)
        
        if(res == 1):
            plt.plot(np.arange(start,i+6),price.values[start:i+6])
            plt.plot(current_idx,current_pat,c="r")
            plt.show()
            plt.savefig('chart1')
        
# Function to check for any retracements
#def is_retracement(moves,level=0.618):
    
csv_files = [f for f in os.listdir('data') if f.endswith('.csv')]

for p in csv_files:

    # Import historical data
    data = pd.read_csv("data/" + p)
    print(p)
    data.Time = pd.to_datetime(data.Time,format = "%Y/%m/%d %H:%M")
    data = data.set_index(data.Time)
    data = data[['Close']]
    price = data.Close
    
    # Detect patterns:
    
    #current_idx,current_pat,start,end = peak_detect2(price.values[:i],n=4,order=10)
    price = price.iloc[-200:]
    price = price.values
    
    # Find out relative local extrema:
    max_ind = list(argrelextrema(price,np.greater,order=10)[0]) # returns a tuple with an array
    min_ind = list(argrelextrema(price,np.less,order=10)[0])
    
    idx = max_ind + min_ind + [len(price)-1]
    idx.sort()
    
    price_pts = price[idx]
    
    # last four points
    last_pts = price_pts[-4:]
    last_idx = idx[-4:]
    
    XA = last_pts[1] - last_pts[0]
    AB = last_pts[2] - last_pts[1]
    BC = last_pts[3] - last_pts[2]
    
    # make a list of the moves
    moves = [XA,AB,BC]
    moves2 = [AB,BC]
    
    # check if it there is a potential trade setup
    # res = is_three_steps(moves,err_allowed= 0.05)
    res = is_level(moves2,err_allowed=0.05,level=0.618)
    
    if res == 1:
        
        # Print and plot the retracement
        print("There is a trade setup:")
#        plt.plot(price)
#        plt.plot(last_idx,last_pts,color='red')
#        plt.title(p.replace(".csv",""))
#        plt.show()
#        plt.savefig('Chart1')
        
        # Send Email: ---------------------------------------------------------
        gmail_user = "paul.nheera.dev@gmail.com"
        gmail_password = "Mhofuu@27"
        
        sent_from = gmail_user
        to = [gmail_user]
        subject = 'Retracement Level Alert!'
        body = "There is a retracement on " + p.replace(".csv","")
        message = 'Subject: {}\n\n{}'.format(subject, body)
        
        try:
            server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
            server.ehlo()
            server.login(gmail_user, gmail_password)
            server.sendmail(sent_from, to, message)
            server.close()
        
            print ('Email sent!')
        except:
            print ('Something went wrong...')
        # ---------------------------------------------------------------------
#------------------------------------------------------------------------------