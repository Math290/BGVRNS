#!/usr/bin/env python
#coding: utf-8

def Addition(ciphertext1,ciphertext2):

        assert len(ciphertext1) == len(ciphertext2)

        d = len(ciphertext1)
        
        return [[ciphertext1[i][0]+ciphertext2[i][0],ciphertext1[i][1]+ciphertext2[i][1]] for i in range(d)]

# Multiplication

# Multiplication
def Multiplication(ciphertext1,ciphertext2):

        assert len(ciphertext1) == len(ciphertext2)

        d = len(ciphertext1)

        res = []
        for i in range(d):
                ctilde0 = ciphertext1[i][0]*ciphertext2[i][0]
                ctilde1 = ciphertext1[i][0]*ciphertext2[i][1] + ciphertext2[i][0]*ciphertext1[i][1]
                ctilde2 = ciphertext1[i][1]*ciphertext2[i][1]
                res.append([ctilde0,ctilde1,ctilde2])
                
        return res