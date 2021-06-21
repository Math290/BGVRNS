#!/usr/bin/env python
#coding: utf-8

def NoiseSize(ciphertext,secretkey,level):

        modq = 1
        for i in range(level+1):
                modq *= Q[i]
        
        Amodq.<X> = PolynomialRing(Integers(modq))
        Rmodq.<x> = Amodq.quotient(X**n+1)
        
        r = len(ciphertext)
        d = len(ciphertext[0])

        cp = deepcopy(ciphertext)#[[ciphertext[i][j] for j in range(d)] for i in range(r)]
                
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
                if tmp[i] >= modq/2:
                        tmp[i] -= modq
                

        tmp = [abs(tmp[i]) for i in range(n)]

        return log(max(tmp)*1.,2) - log(1.*t,2)