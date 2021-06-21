#!/usr/bin/env python
#coding: utf-8

import math
import random
import numpy as np
from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
k = 2
Q = [131, next_prime(131)]
q = 1
for i in range(k):
        q *= Q[i]
t = 2
n = 4
sigma = 3.2
w = 2
lw = floor(log(q,w)) + 1

Z = IntegerRing()
A.<X> = PolynomialRing(Z)
R.<x> = A.quotient(X**n+1)#Univariate Quotient Polynomial Ring

At.<X> = PolynomialRing(Integers(t))#
Rt.<x> = At.quotient(X^n+1)

Aq.<X> = PolynomialRing(Integers(q))#
Rq.<x> = Aq.quotient(X**n+1)#
Aw.<X> = PolynomialRing(Integers(w))#
Rw.<x> = Aw.quotient(X**n+1)

AQ = [PolynomialRing(Integers(Q[i]),X) for i in range(k)]
RQ = []
for i in range(k):
        tmp.<x> = AQ[i].quotient(X**n+1)
        RQ.append(tmp)

Xkey = [-1,0,1]
D = DiscreteGaussianDistributionIntegerSampler(sigma=sigma) #Échantillonneur gaussien discret sur les nombres entiers
def KeyGen():
	#clé secrète
	skA=R([random.choice(Xkey) for i in range(n)])
	a=R([random.choice([0..q-1]) for i in range(n)])
	#Element dans Xerr
	e=R([D() for i in range(n)])
	#Clé publique
	pkA = [[RQ[i](a*skA+t*e),RQ[i](-a)] for i in range(k)]
	#Génération de l clé publique d'évaluation
	rlk = []
	po = 1
	for i in range(lw):

		ai=R([random.choice([0..q-1]) for i in range(n)])

		ei=R([D() for i in range(n)])

		rlk.append([[RQ[i](skA**2*po + ai*skA + t*ei),RQ[i](-ai)] for i in range(k)])

		po*=w
	return pkA, skA,rlk
def Encryption(plaintext,pk):
        e0=R([D() for i in range(n)])
        e1=R([D() for i in range(n)])

        u=R([random.choice(Xkey) for i in range(n)])
        
        cipher = [[RQ[i](list(plaintext)) + RQ[i](u)*pk[i][0] + RQ[i](t*e0) ,RQ[i](u)*pk[i][1] + RQ[i](t*e1)] for i in range(k)]
        return cipher  

def Decryption(ciphertext,secretkey,level):

        assert len(ciphertext) == level + 1
        
        modq = 1
        for i in range(level+1):
                modq *= Q[i]
                
        Amodq.<X> = PolynomialRing(Integers(modq))
        Rmodq.<x> = Amodq.quotient(X**n+1)

        r = len(ciphertext)
        d = len(ciphertext[0])

        cp =deepcopy(ciphertext)#[[ciphertext[i][j] for j in range(d)] for i in range(r)]

        for i in range(r):
                tmp = int(modq/Q[i])
                for j in range(d):
                        cp[i][j] /= tmp                              
        
        tmp = [ [R(list(cp[i][j])) for j in range(d)] for i in range(r)]        
        
        res = []
        for i in range(d):
                ci = 0
                for j in range(r):
                        ci += tmp[j][i]*int(modq/Q[j])
                res.append(Rmodq(list(ci)))

        tmp = res[0]
        for i in range(1,d):
                tmp += res[i]*Rmodq(list(secretkey**i))

        tmp = list(tmp)
                
        tmp = [Integer(tmp[i]) for i in range(n)]
        
        for i in range(n):
                if tmp[i] > modq/2:
                        tmp[i] -= modq
        
        return Rt(tmp)