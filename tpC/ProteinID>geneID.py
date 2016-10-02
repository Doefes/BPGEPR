#!/bin/python

  import os

  def genes(filenaam,bestandsnaam):
    bestand = open(filenaam, "r")
    lijst = bestand.read().splitlines()
    for line in bestand:
      lijst.append(line)
    for i in range (1,78):
      code = str(lijst[i])
      os.system("""wget -i -q -O- http://www.ncbi.nlm.nih.gov/gene/?term=""" + code + """ | egrep "Gene ID" | awk -F ":" '{print $2}'| awk -F ", " '{print $1}' >> 			""" + bestandsnaam )
  def main():	
    genes("blast_resultaat_gefilterd_rna.txt", "geneid.txt")

  main()
