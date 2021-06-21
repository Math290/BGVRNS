#!/usr/bin/env python
#coding: utf-8

def Modulus_Switching(ciphertext):

        r = len(ciphertext)

        d = len(ciphertext[r-1])
        delta = [ciphertext[r-1][j] for j in range(d)]
        
        for i in range(d):
                delta[i] *= -t.inverse_mod(Q[r-1])
                delta[i] = R(list(delta[i]))
                delta[i] *= t

        cp = [[ciphertext[i][j] for j in range(d)] for i in range(r-1)]

        for i in range(r-1):
                cp[i] = [cp[i][j] + RQ[i](list(delta[j])) for j in range(d) ]
                cp[i] = [ cp[i][j]*Q[r-1].inverse_mod(Q[i]) for j in range(d) ]

        return cp
def Decomprand_w(cmult2):
        r = len(cmult2)
        modq = 1
        for i in range(r):
                modq *= Q[i]

        lwq = floor(log(modq,w))+1
                
        Amodq.<X> = PolynomialRing(Integers(modq))
        Rmodq.<x> = Amodq.quotient(X**n+1)

        cp = deepcopy(cmult2)#[c2[i] for i in range(r)]

        for i in range(r):
                tmp = int(modq/Q[i])
                cp[i] /= tmp

        tmp = [ R(list(cp[i])) for i in range(r)]        

        c = 0
        for i in range(r):
                c += tmp[i]*int(modq/Q[i])

        c = Rmodq(list(c))
        c = list(c)
        c = [Integer(c[i]) for i in range(len(c))]
 
        res = []
        for i in range(lwq):
                res.append( R([ c[i]%w for i in range(len(c))]) )
                c = [floor(c[i]/w) for i in range(len(c))]  
        
        return res

def Powersof(b,w):
	res = []
	for j in range(lw):
		res.append(Rq([(b[i]*w**j) for i in range(n)]))
	return res

# a=Rq.random_element()
# b=Rq.random_element()
# Da=Decomprand_w(a,w)
# Pb=Powersof(b,w)
# prod =[Rq(list(x))*Rq(list(y)) for x,y in zip(Da,Pb)]
# s=0
# for i in range(len(prod)):
# 	s+=prod[i]
# print(a*b==s)
def Relinearisation(ciphertext,rlk):

        r = len(ciphertext)

        c2 = []
        #On récupère les ct[0][2] et ct[1][2]
        for i in range(r):
                c2.append(ciphertext[i][2])
                
        D =Decomprand_w(c2)
        lwmodq = len(D)
        
        scalprod = []
        #produit scalaire entre Dw et la clé de rélinéarisation
        for i in range(r):
                tmp = [0,0]
                for l in range(lwmodq):
                        tmp = [tmp[0] + RQ[i](D[l])*rlk[l][i][0], tmp[1] + RQ[i](D[l])*rlk[l][i][1] ]
                scalprod.append(tmp)
        #chiffré rélinériser
        res = [[ciphertext[i][0] + scalprod[i][0], ciphertext[i][1] + scalprod[i][1]] for i in range(r)]
        
        return res