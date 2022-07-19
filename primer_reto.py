import sys
import json
import requests
import pandas as pd

# request JSON from URL
r = requests.get('https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=perl&site=stackoverflow')
data = r.json()

# Numero de preguntas contestadas y no contestadas, me ayudo de un diccionario para llevar un conteo
preguntas = {'Contestadas': 0, 'No Contestadas': 0}

for item in data['items']:
    if item['is_answered'] == True:
        preguntas['Contestadas'] += 1
    elif item['is_answered'] == False:
        preguntas['No Contestadas'] += 1
   
for k, v in preguntas.items():
    print("Preguntas {0}: {1}".format(k, v))
print("")

# Pregunta con menor cantidad de visitas
# ordeno la informacion por cantidad de visitas y el primer elemento para responder
result = sorted(data['items'], key=lambda x: x['view_count'])
print("La pregunta con menor numero de vistas es \"{0}\" con {1} vistas".format(result[0]['title'], result[0]['view_count']))
print("La direccion URL de esta pregunta es: {0}\n".format(result[0]['link']))

# Pregunta mas actual y mas antigua
# ordeno la informacion usando los segundos en 'creation_date'
# obtengo respuestas usando primer y ultimo elemento
result = sorted(data['items'], key=lambda x: x['creation_date'])

print("La pregunta mas antigua es: \"{0}\"".format(result[0]['title']))
print("Creada el dia y hora: {0}".format(pd.to_datetime(result[0]['creation_date'], unit='s')))
print("La direccion URL de esta pregunta es: {0}\n".format(result[0]['link']))

print("La pregunta mas reciente es: \"{0}\"".format(result[-1]['title']))
print("Creada el dia y hora: {0}".format(pd.to_datetime(result[-1]['creation_date'], unit='s')))
print("La direccion URL de esta pregunta es: {0}\n".format(result[-1]['link']))

# obtener la respuesta del owner que tenga mayor reputacion
# ordeno la informacion usando el valor de la reputacion
# obtengo la respuesta usando el primer elemento de la lista obtenida previamente
result = sorted(data['items'], key=lambda x: x['owner']['reputation'])

print("La mayor reputacion tiene un valor de {0} y pertenece al usuario {1}".format(result[-1]['owner']['reputation'],result[-1]['owner']['display_name']))
print("Y la pregunta de este usuario fue \"{0}\"".format(result[-1]['title']))
print("Se puede visitar a esta pregunta en la siguiente URL: {0}".format(result[-1]['link']))


"""
Por ultimo, se que por lejos esta es la mejor solucion pero es la primera vez que uso JSON
y fue muy interesante, lo siguiente seria descomponer esta logica en OOP y considerar
el tiempo de complejidad asi como la complejidad espacial (procesamiento y memoria).
No se hacer pruebas unitarias pero estoy seguro que estudiare este tema muy pronto


Muchas gracias por tomar el tiempo para evaluar esta prueba
"""
