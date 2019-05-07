# Importing libaries - Pandas used to read and manipulate data
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import seaborn as sns # plotting
import sklearn as sk

# Import in house made tools
from tools import VisualizationTools as vis
from tools import ProcessingTools as pt


def ProcessMacroFeatData(Data,outDir='./',sigma=5,slideNorm=False,dimReduction=False):
    ## Header Data
    dataHdr=Data.iloc[:,-4:len(Data.columns)]

    ################################## Correct Curvature Sign for Subjects ##############################
    # Quality Control - These subjects had incorrect Curvature signs maunally correcting
    SlideNames = (
        ('EPI_P027_Neo_05_NEUN', 2),
        ('EPI_P033_Neo_06_NEUN', 1),
        ('EPI_P046_Neo_05_NEUN', 1),
        ('EPI_P046_Neo_05_NEUN', 2),
        ('EPI_P051_Neo_08_NEUN', 1),
        ('EPI_P058_Neo_08_NEUN', 1),
        ('EPI_P066_Neo_08_NEUN', 1),
        ('EPI_P079_Neo_04_NEUN', 1),
    )
     
    for slide, comp in SlideNames:
     
        idx = Data[(Data['Component'] == comp) & (Data['Subject'] == slide)].index
        Data.ix[idx,"Curvature"]=-1*Data.ix[idx,"Curvature"] 

    ################################## Predictive Features (X) ##########################################
    # create a DataFrame called `X` holding the predictive features.
    # Features include only Curvature and Thickness Metrics
    X["Curvature"]=Data["Curvature"]
    X["Thickness"]=Data["Thickness"]


    ############### Withing Slide Smoothing (OPTINAL - Data is already smoothed) ########################

    X=pt.smoothSlideFeat(X,dataHdr,sigma)


    ##################################### Macrofeature Filtering #########################################

    Xz['Curvature_zscore']=sp.signal.medfilt(Xz['Curvature_zscore'],kernel_size=11)
    Xz['Thickness_zscore']=sp.signal.medfilt(Xz['Thickness_zscore'],kernel_size=11)

    Xout=Xz

    print("Macroscale Features Filtered Using Median Filter")


    ########################################   Return Data    ############################################
    print("###########################################################################################")
    print(Xout.head(n=5))
    print("###########################################################################################")
    Data=pd.concat([X,dataHdr],axis=1)
    return Data,Xout,dataHdr
