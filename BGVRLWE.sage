#!/usr/bin/env python
#coding: utf-8
attach("EncyptionBGV.sage")
attach("OperationsBGV.sage")
attach("NoiseSize.sage")
attach("ModuleSwitching&Relin.sage")



pk,sk,rlk=KeyGen()
m1 = Rt.random_element()
ct1 = Encryption(m1,pk)
Bdec = q/(2*t) - 0.5

m2 = Rt.random_element()
ct2 = Encryption(m2,pk)
cadd = Addition(ct1,ct2)
cmult = Multiplication(ct1,ct2)
print ("log(Bdec)", log(Bdec,2)) 

print( "\nDec(ct1) == m1: ", Decryption(ct1,sk,1) == m1)
print ("Dec(ct2) == m2: ", Decryption(ct2,sk,1) == m2)

print ("\nNoiseSize(ct1) = ", NoiseSize(ct1,sk,1))
print ("NoiseSize(ct2) = ", NoiseSize(ct2,sk,1))
print ("\nNoiseSize(ctadd) = ", NoiseSize(cadd,sk,1))
print ("NoiseSize(ctmult) = ", NoiseSize(cmult,sk,1))

print ("\nDec(cadd) == m1+m2: ", Decryption(cadd,sk,1) == m1+m2)
print ("Dec(cmult) == m1*m2: ", Decryption(cmult,sk,1) == m1*m2)

crelin = Relinearisation(cmult,rlk)
print ("\nDec(crelin) == m1*m2: ", Decryption(crelin,sk,1) == m1*m2)
print ("NoiseSize(crelin) = ", NoiseSize(crelin,sk,1))

cmodswitch =Modulus_Switching(cmult)
print ("\nDec(cmodswitch) == m1*m2: ", Decryption(cmodswitch,sk,0) == m1*m2)
print ("NoiseSize(cmodswitch) = ", NoiseSize(cmodswitch,sk,0))

crelin = Relinearisation(cmodswitch,rlk)
print ("\nDec(crelin) == m1*m2: ", Decryption(crelin,sk,0) == m1*m2)
print ("NoiseSize(crelin) = ", NoiseSize(crelin,sk,0))


#Key Switching
# Lemmme
# def Decomprand_w(a,w):
# 	res =[]
# 	tmp =list(a)
# 	tmp = [Integer(tmp[i]) for i in range(n)]
# 	for j in range(lw):
# 		res.append((Rw([floor(tmp[i]/w**j) for i in range(n)])))

# 	return res



































































