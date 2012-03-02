import os
import redis
from pyres import ResQ
from pyres import failure
from base64 import b64decode

def index():
	HOST = 'localhost:6379'
	resq = ResQ(HOST)

	#resq.push('aa','bb')
	print resq.pop('aa')

if __name__ == "__main__":
	index()
