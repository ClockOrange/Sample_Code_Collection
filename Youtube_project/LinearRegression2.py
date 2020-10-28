import pandas as pd
import numpy as np
from scipy.optimize import minimize
from scipy.stats import norm
from sklearn.model_selection import train_test_split

class LinearRegression:
    
    def __init__(self, X, y):
        
        def find_sse(beta):
            y_hat = beta[0] + np.sum(beta[1:] * self.data, axis=1)
            return np.sum((self.y - y_hat)**2)
        
        self.data = np.array(X)
        self.y = np.array(y)
        self.n_observations = len(self.y)
        
        beta_guess = np.zeros(self.data.shape[1] + 1)
        min_results = minimize(find_sse, beta_guess)
        self.coefficients = min_results.x
        
        self.y_predicted = self.predict(self.data)
        self.residuals = self.y - self.y_predicted
        self.sse = np.sum(self.residuals**2)
        self.r_squared = 1 - self.sse / np.sum((self.y - np.mean(self.y))**2)
        self.rse = (self.sse / (self.n_observations - 2))**0.5
        self.loglik = np.sum((np.log(norm.pdf(self.residuals, 0, self.rse))))
        
        
    def predict(self, X):
        X = np.array(X)
        return self.coefficients[0] + np.sum(self.coefficients[1:]*X, axis=1)
    
    def summary(self):
        print('+-----------------------------+')
        print('|  Linear Regression Summary  |')
        print('+-----------------------------+')
        print('Number of training observations:', self.n_observations)
        # print('Coefficient Estimates:\n  ', self.coefficients)
        print('Residual Standard Error:', self.rse)
        print('r-Squared:', self.r_squared)
        print('Log-Likelihood', self.loglik)
        print()
    
    def score(self,X,y):
        X = np.array(X)
        y = np.array(y)
        
        y_hat = self.predict(X)
        sse = np.sum( (y - y_hat)**2 )
        return 1 - sse / np.sum((y - np.mean(y))**2)

#test code go below
# width = [6.4, 7.7, 6.7, 7.4, 6.5, 6.9, 7.8, 7.6, 6.2, 7.4, 7.7, 6.8] 
# height = [8.2, 7.5, 6.6, 8.8, 6.8, 6.8, 7.6, 8.8, 8.4, 7.3, 7.4, 7.2] 
X = pd.read_csv('Text_vector_all.csv')
X = X.drop(columns = ["Unnamed: 0"])


Y = pd.read_csv('ChannelVideo.csv')

Y_train = Y["like"] / (Y["dislike"] + Y["like"])

X_val, X_test, y_val, y_test = train_test_split(X, Y_train, train_size=0.75,test_size = 0.25, random_state=100)
mod = LinearRegression(X_val,y_val)
mod.summary()
# fruit_mod.confusion_matrix(X,y)
# X_test = pd.DataFrame({'x1':[7.4, 7.1, 6.4], 'x2':[7.2, 7.8, 6.8]}) 
# y_test = [6.6, 8.8, 6.8]
print("test score ",mod.score(X_test,y_test))