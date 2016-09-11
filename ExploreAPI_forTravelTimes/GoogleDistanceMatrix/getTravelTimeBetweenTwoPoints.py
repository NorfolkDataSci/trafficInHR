# -*- coding: utf-8 -*-
"""
Created on Sat Sep 10 15:03:26 2016

@author: christopher.brossman

This gets the time and duration between newport news and norfolk
using google https://developers.google.com/maps/documentation/distance-matrix/intro

this opens a csv and stores the information every fifteen minutes into a csv file using windows scheduler

"""
import urllib
import json
import time
import datetime
import os
import pandas as pd

path = 'C:\\Users\\christopher.brossman\\Documents\\'
os.chdir(path)
fname = 'NorfolkToNewportNews_TravelTimes.csv'
df = pd.read_csv(path + fname)

baseURL = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins='
origin = 'Norfolk, VA'
destination = 'Newport News, VA'
YOUR_API_KEY = '<Put your key here>'

def getTravelTime(origin,destination,APIkey):
    baseURL = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&'
    f = {'origins': origin, 'destinations' : destination, 'key' : APIkey}
    params = urllib.parse.urlencode(f)
    url = baseURL + params
    r = urllib.request.urlopen(url)
    #get time of request
    ts = time.time()
    rText = r.read().decode(r.info().get_param('charset') or 'utf-8')    
    data = json.loads(rText)
    distText = data['rows'][0]['elements'][0]['distance']['text']
    durText = data['rows'][0]['elements'][0]['duration']['text']
    st = str(datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S'))
    info = [st, distText, durText]
    return info
    
travelInfo = getTravelTime(origin,destination,YOUR_API_KEY)
df.loc[len(df)]= travelInfo
df.to_csv(path + fname, index = False)

    
    
    

