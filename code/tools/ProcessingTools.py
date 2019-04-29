############################################## Signal Processing Functions ##########################################
import scipy.ndimage
import scipy.signal
import numpy as np
import pandas as pd
import scipy as sp


def smooth(a,WSZ):
    ##################################################################################################################
    #Description: # Similar implentaion to MATLAB SMOOTH
    
    #Inputs:
    # <a>: NumPy 1-D array containing the data to be smoothed
    # <WSZ>: smoothing window size needs, which must be odd number,
    # as in the original MATLAB implementation

    #Outputs: 
    # Smoothed numpy array

    ##################################################################################################################

    out0 = np.convolve(a,np.ones(WSZ,dtype=int),'valid')/WSZ    
    r = np.arange(1,WSZ-1,2)
    start = np.cumsum(a[:WSZ-1])[::2]/r
    stop = (np.cumsum(a[:-WSZ:-1])[::2]/r)[::-1]
    return np.concatenate((  start , out0, stop  ))


def smoothSlideProfiles(Data,hdrData,sigma=5):
    ##################################################################################################################
    # Description:
    # Function to horizontally smooth acorss profiles 

    #Inputs:
    # <Data>: Pandas Dataframe containing data from a specific featuremap eg).Density, Area, Eccentricty
    # <hdrData>: Pandas Datafram containing header information describing each profile 

    #Outputs:
    # <dataOut>: Pandas Dataframe containing smooted data from a specific featuremap eg).Density,Area,Eccentricty

    ##################################################################################################################

    subjList=list(dict.fromkeys(hdrData["Subject"])) 
    numSubj=len(subjList)
    dataOut=Data.copy(deep=True)


    for i in range(0,numSubj):
    
        slide=subjList[i]
        temp=hdrData[hdrData['Subject']==slide]
        numComp=temp['Component'].max()
    
        for comp in range(1,numComp+1):
            idx = Data[(hdrData['Component'] == comp) & (hdrData['Subject'] == slide)].index
            numCols=len(Data.columns)
            
            for cols in range(0,numCols):
                    # smooth data here
                    dataOut.iloc[idx,cols]=sp.ndimage.filters.gaussian_filter(Data.iloc[idx,cols],sigma=sigma,mode='reflect')
                    #dataOut.iloc[idx,cols]=smooth(Data.iloc[idx,cols],31)
    return dataOut

def slideNormalization(Data,hdrData):
    ##################################################################################################################
    # Description:
    # Normalize data within individual slides 

    #Inputs:
    # <Data>: Pandas Dataframe containing data from a specific featuremap eg).Density, Area, Eccentricty
    # <hdrData>: Pandas Datafram containing header information describing each profile 

    #Outputs:
    # <dataOut>: Pandas Dataframe containing smooted data from a specific featuremap eg).Density,Area,Eccentricty

    ##################################################################################################################

    subjList=list(dict.fromkeys(hdrData["Subject"])) 
    numSubj=len(subjList)
    dataOut=Data.copy(deep=True)

    for i in range(0,numSubj):
    
        slide=subjList[i]
        temp=hdrData[hdrData['Subject']==slide]

        idx = Data[(hdrData['Subject'] == slide)].index
        numCols=len(Data.columns)
        temp=Data.iloc[idx,0:1000].values
        # Z score Normalization
        dataOut.iloc[idx,0:1000] = ( Data.iloc[idx,0:1000] - np.mean(temp.flatten()) )/( np.std(temp.flatten()) )
                     
    return dataOut


def getProfileShapeFeat(X):
    ##################################################################################################################
    # Description:
    # Amunts & Zillies Distrubution Features 
    # Program will extract features that describe the shape of individual profiles. 
    # Profile shape is quantified using a set of 10 features described by 
    # Shleicher et al., 1998 (Observer-Independent Method for Microstructural
    # Parcellation of Cerebral Cortex: A Quantitative Approach to Cytoarchitectonics )

    # Feature Extracted:
    # 1) Mean Amplitude 6)  Derivative (m0) -- Mean
    # 2) Mean in X      7)  Derivative (m0) -- Mean in X
    # 3) Momement1 (m1) 8)  Derivative (m1) -- Variance
    # 4) Momement2 (m2) 9)  Derivative (m2) -- Skewness
    # 5) Momement3 (m3) 10) Derivative (m3) -- Kurtosis

    # NOTE: All the moments are computed using a divisor of n rather than 
    # n – 1, where n is the length of the vector (as outlined in moment documentation)
 
    # NOTE: We are only intrested in the absolute value of the first derivative
    # (differential quotient) 
    
    ##################################################################################################################
    
    cols = list(X.columns)
    Xfeat=pd.DataFrame()
    sz=X.shape
    numFeat=10
    feat = np.zeros((sz[0],numFeat))
    
    for i in range(0,sz[0]):
        Profile=smooth(X.iloc[i,:].values,101)

        # Mean
        f0=np.mean(Profile)
        feat[i,0]=f0
        #feat=np.append(feat,f0)

        # Mean in X direction
        tmp=Profile/np.sum(Profile)
        f1=np.matmul(tmp, np.array([range(1,len(Profile)+1)]).transpose())
        feat[i,1]=f1[0]
        #feat=np.append(feat,f1)

        # Variance
        f2=sp.stats.moment(Profile,2)
        feat[i,2]=f2
        #feat=np.append(feat,f2)

        #Skewness
        f3=sp.stats.moment(Profile,3)
        feat[i,3]=f3
        #feat=np.append(feat,f3)

        #Kurtosis
        f4=sp.stats.moment(Profile,4)
        feat[i,4]=f4
        #feat=np.append(feat,f4)

        # Differential Quiotent Features 
        profile_deriv = abs(np.diff(Profile))

        # Mean
        f5=np.mean(profile_deriv)
        feat[i,5]=f5

        # Mean in X direction
        tmp=profile_deriv/np.sum(profile_deriv)
        f6=np.matmul(tmp, np.array([range(1,len(profile_deriv)+1)]).transpose())
        feat[i,6]=f6

        # Variance
        f7=sp.stats.moment(profile_deriv,2)
        feat[i,7]=f7

        #Skewness
        f8=sp.stats.moment(profile_deriv,3)
        feat[i,8]=f8

        #Kurtosis
        f9=sp.stats.moment(profile_deriv,4)
        feat[i,9]=f9

    for col in range(0,10):
        col_Feat = cols[col]
        Xfeat[col_Feat]=feat[:,col]
        
    return Xfeat
            
