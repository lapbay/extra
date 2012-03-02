#!/usr/bin/env python
from APNSWrapper import *
import binascii

deviceToken = binascii.unhexlify('cb86b176ee99ae5f3387c79f1226d234599e91c7bc300e97afb034cc0009e192');
wrapper = APNSNotificationWrapper('ck.pem', True)
message = APNSNotification()
message.token(deviceToken)
message.alert("Very simple alert")
message.badge(1)
message.sound()
wrapper.append(message)
wrapper.notify()
