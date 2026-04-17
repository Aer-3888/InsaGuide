#!/usr/bin/python3
import pandas as pd
import pydot
from IPython.display import SVG, display    

class Node:
    def __init__(self):
        self.nodequestion=""
        self.nodeg=""
        self.noded=""        
        self.edgeq=""
        self.edgeg=""
        self.edged=""
        self.gain=-1
        self.datag=""        
        self.datad="" 
   
    def remove(self,groot):
        groot.del_node(self.nodequestion)
        groot.del_node(self.nodeg)
        groot.del_node(self.noded)
        groot.del_edge(self.edgeq)
        groot.del_edge(self.edgeg)
        groot.del_edge(self.edged)
    def connecte(self,groot):
        groot.add_node(self.nodequestion)
        groot.add_node(self.nodeg)
        groot.add_node(self.noded)
        groot.add_edge(self.edgeq)
        groot.add_edge(self.edgeg)
        groot.add_edge(self.edged)        

        
        
      
class pedagogicTree:
    
    image = pydot.Dot(format='svg',graph_type='graph',strict=True, nojustify=True)
    image.set_node_defaults(color='blanchedalmond',
                            style='filled',
                            shape='box',
                            fontname='Courier',
                            fontsize='8')
    final_image= pydot.Dot(format='svg',graph_type='graph',strict=True, nojustify=True)
    final_image.set_node_defaults(color='blanchedalmond',
                            style='filled',
                            shape='box',
                            fontname='Courier',
                            fontsize='8')
    num=0
    def __init__(self,data,gnode=None):      
        self.data = data
        self.currentNode=Node()
        self.bestNode=Node()
        self.gnode=gnode
         
        if gnode==None:
            self.gnode = pydot.Node('root',label=self.data.to_markdown())
            pedagogicTree.image.add_node(self.gnode)
            pedagogicTree.final_image.add_node(self.gnode)
        
        labels=list(data.columns)
        self.target=labels.pop()
        self.classes=list(set(data[self.target].values)) 

        self.IMGLIST = [] 
    def images(self):
        return self.IMGLIST
    def FILLLIST(self,tree):
        import copy
        from numpy import asarray
        name= 'tmp'+str(pedagogicTree.num)+'.png'
        namesvg= 'tmp'+str(pedagogicTree.num)+'.svg'
        tree.write_png(name)
        tree.write_svg(namesvg)
        from PIL import Image # importing image module 
        img = Image.open(name)
        self.IMGLIST.append(img)
    def leaf(self):
        pedagogicTree.num+=1
        self.bestNode.nodequestion = pydot.Node('q'+str(self.num),label=self.data.to_markdown(),fonsize=10,color='red')       
        self.bestNode.edgeq = pydot.Edge(self.gnode.get_name(),self.bestNode.nodequestion.get_name())  
        self.bestNode.connecte(pedagogicTree.final_image)
        svg = self.image.create_svg()
        self.FILLLIST(pedagogicTree.final_image)

    def fit(self):
        
        
        if len(set(self.data[self.data.columns[-1]].values))==1:        
            return #self.leaf()
        
       
        for c in self.data.columns[:-1]: #bien sur on ne etste pas la colonne des prédictions        
            feat = list(set(self.data[c].values))
            if len(feat)==1: #pas de split si tout le monde a la même valeur de feature
                feat.pop() #on vide pour pas passer dans le prochain for (je ne sais pas si next marche)
                next
            if len(feat)==2: #si 2 valeurs seulement, tester sur une seule car splits symétriques
                feat.pop()
            for f in feat:
                pedagogicTree.num+=1
                gsplit=self.data[self.data[c] == f]
                rsplit=self.data[self.data[c] != f]                
                self.printTree(gsplit,rsplit,c,f)
        print("Résultat final\n")
        self.bestNode.connecte(pedagogicTree.final_image)
        svg = pedagogicTree.final_image.create_svg()
        self.FILLLIST(pedagogicTree.final_image)

        bg =pedagogicTree(self.bestNode.datag,self.bestNode.nodeg)
        bg.fit()
        bd =pedagogicTree(self.bestNode.datad,self.bestNode.noded)
        bd.fit()
        


    def entropie(self,feuille):
        import math
        taille=len(feuille.index)
        entropieStr="entropie = -("
        entropie=0
        for c in self.classes:
            pStr=str(len(feuille[feuille[self.target] == c].index))+'/'+str(taille)
            p=len(feuille[feuille[self.target] == c].index)/taille
            entropieStr+=pStr+'*log2('+pStr+') + '
            if p>0:
                entropie+=p*math.log2(p)
        entropieStr=entropieStr.rstrip('+')
        entropieStr+=') = '+"{:.2f}".format(-1*entropie)
        return -1*entropie,entropieStr

    def printTree(self,gauche,droit,c,f):
        entropie,entropieStr=self.entropie(self.data)
        entropieg,entropieStrg=self.entropie(gauche)
        entropied,entropieStrd=self.entropie(droit)
        entropiesplit=len(gauche.index)/len(self.data.index)*entropieg+len(droit.index)/len(self.data.index)*entropied
        entropiesplitStr='entropieSPLIT = '+str(len(gauche.index))+'/'+str(len(self.data.index))+'*'+"{:.2f}".format(entropieg)+' + '+str(len(droit.index))+'/'+str(len(self.data.index))+'*'+"{:.2f}".format(entropied)+' = '+'{:.2f}'.format(entropiesplit)
        gain = entropie-entropiesplit       
       
        self.currentNode.nodequestion = pydot.Node('q'+str(self.num),label=c+'=='+f+'\n\n'+entropieStr+'\n'+entropiesplitStr+'\nGAIN = '+'{:.2f}'.format(gain),fonsize=10)       
        self.currentNode.nodeg = pydot.Node('tg'+str(self.num),label=gauche.to_markdown()+"\n\n"+entropieStrg,color='lawngreen')
        self.currentNode.noded = pydot.Node('td'+str(self.num),label=droit.to_markdown()+"\n\n"+entropieStrd ,color='azure')
        self.currentNode.edgeq = pydot.Edge(self.gnode.get_name(),self.currentNode.nodequestion.get_name())
        self.currentNode.edgeg = pydot.Edge(self.currentNode.nodequestion.get_name(),self.currentNode.nodeg.get_name(),label='oui')
        self.currentNode.edged = pydot.Edge(self.currentNode.nodequestion.get_name(),self.currentNode.noded.get_name(),label='non')
        self.currentNode.connecte(pedagogicTree.image)
        svg = pedagogicTree.image.create_svg()
        self.FILLLIST(pedagogicTree.image)
        #self.currentNode.remove(self.image)
        #input("Press Enter to continue...")
        import copy
        if gain > self.bestNode.gain:
            self.bestNode=copy.deepcopy(self.currentNode)
            self.bestNode.gain=gain
            self.bestNode.datag=gauche
            self.bestNode.datad=droit

        
        


if __name__ == '__main__':

    data = pd.read_csv('toy.csv')
    pt= pedagogicTree(data)
    pt.fit()

