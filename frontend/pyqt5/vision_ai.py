import os, io
from google.cloud import vision_v1
from google.cloud.vision_v1 import types
import pandas as pd

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'shaped-gravity-364218-248dcbf1d40a.json'

client = vision_v1.ImageAnnotatorClient()

FOLDER_PATH = r'C:\Users\ROG\Pictures\Saved Pictures'
IMAGE_FILE = 'test.jpg'
FILE_PATH = os.path.join(FOLDER_PATH, IMAGE_FILE)
with io.open(FILE_PATH, 'rb') as image_file:
    content = image_file.read()

image = vision_v1.types.Image(content=content)
response = client.document_text_detection(image=image)
docText = response.full_text_annotation.text
print(docText)





















